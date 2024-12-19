import '../models/recipe.dart';
import '../models/system_component.dart';
import '../providers/system_copmonent_provider.dart';
import '../models/data_point.dart';
import '../models/safety_error.dart';
import '../../../features/alarm/models/alarm.dart';

class RecipeExecutionService {
  final SystemComponentProvider _componentProvider;

  RecipeExecutionService(this._componentProvider);

  Future<void> executeSteps(List<RecipeStep> steps, {
    double? inheritedTemperature,
    double? inheritedPressure,
    required Function(String, ComponentStatus) logCallback,
    required bool isSystemRunning,
  }) async {
    for (var step in steps) {
      if (!isSystemRunning) break;
      await executeStep(step,
        inheritedTemperature: inheritedTemperature,
        inheritedPressure: inheritedPressure,
        logCallback: logCallback,
        isSystemRunning: isSystemRunning
      );
    }
  }

  Future<void> executeStep(RecipeStep step, {
    double? inheritedTemperature,
    double? inheritedPressure,
    required Function(String, ComponentStatus) logCallback,
    required bool isSystemRunning,
  }) async {
    if (!isSystemRunning) return;

    logCallback(_getStepDescription(step), ComponentStatus.normal);

    switch (step.type) {
      case StepType.valve:
        await _executeValveStep(step, logCallback);
        break;
      case StepType.purge:
        await _executePurgeStep(step, logCallback);
        break;
      case StepType.loop:
        await _executeLoopStep(step, inheritedTemperature, inheritedPressure, logCallback, isSystemRunning);
        break;
      case StepType.setParameter:
        await _executeSetParameterStep(step, logCallback);
        break;
    }
  }

  String _getStepDescription(RecipeStep step) {
    switch (step.type) {
      case StepType.valve:
        return 'Open ${step.parameters['valveType']} for ${step.parameters['duration']} seconds';
      case StepType.purge:
        return 'Purge for ${step.parameters['duration']} seconds';
      case StepType.loop:
        return 'Loop ${step.parameters['iterations']} times';
      case StepType.setParameter:
        return 'Set ${step.parameters['parameter']} of ${step.parameters['component']} to ${step.parameters['value']}';
      default:
        return 'Unknown step type';
    }
  }

  Future<void> _executeValveStep(RecipeStep step, Function(String, ComponentStatus) logCallback) async {
    ValveType valveType = step.parameters['valveType'] as ValveType;
    int duration = step.parameters['duration'] as int;
    String valveName = valveType == ValveType.valveA ? 'Valve 1' : 'Valve 2';

    _componentProvider.addParameterDataPoint(
      valveName,
      'status',
      DataPoint(timestamp: DateTime.now(), value: 1.0)
    );
    logCallback('$valveName opened for $duration seconds', ComponentStatus.normal);

    await Future.delayed(Duration(seconds: duration));

    _componentProvider.addParameterDataPoint(
      valveName,
      'status',
      DataPoint(timestamp: DateTime.now(), value: 0.0)
    );
    logCallback('$valveName closed after $duration seconds', ComponentStatus.normal);
  }

  Future<void> _executePurgeStep(RecipeStep step, Function(String, ComponentStatus) logCallback) async {
    int duration = step.parameters['duration'] as int;

    _componentProvider.updateComponentCurrentValues('Valve 1', {'status': 0.0});
    _componentProvider.updateComponentCurrentValues('Valve 2', {'status': 0.0});
    _componentProvider.updateComponentCurrentValues('MFC', {'flow_rate': 100.0});
    logCallback('Purge started for $duration seconds', ComponentStatus.normal);

    await Future.delayed(Duration(seconds: duration));

    _componentProvider.updateComponentCurrentValues('MFC', {'flow_rate': 0.0});
    logCallback('Purge completed after $duration seconds', ComponentStatus.normal);
  }

  Future<void> _executeLoopStep(
    RecipeStep step,
    double? parentTemperature,
    double? parentPressure,
    Function(String, ComponentStatus) logCallback,
    bool isSystemRunning,
  ) async {
    int iterations = step.parameters['iterations'] as int;
    double? loopTemperature = step.parameters['temperature'] != null
        ? (step.parameters['temperature'] as num).toDouble()
        : null;
    double? loopPressure = step.parameters['pressure'] != null
        ? (step.parameters['pressure'] as num).toDouble()
        : null;

    double effectiveTemperature = loopTemperature ??
        _componentProvider.getComponent('Reaction Chamber')!.currentValues['temperature']!;
    double effectivePressure = loopPressure ??
        _componentProvider.getComponent('Reaction Chamber')!.currentValues['pressure']!;

    for (int i = 0; i < iterations; i++) {
      if (!isSystemRunning) break;
      logCallback('Starting loop iteration ${i + 1} of $iterations', ComponentStatus.normal);

      await _setReactionChamberParameters(effectiveTemperature, effectivePressure, logCallback);

      await executeSteps(
        step.subSteps ?? [],
        inheritedTemperature: effectiveTemperature,
        inheritedPressure: effectivePressure,
        logCallback: logCallback,
        isSystemRunning: isSystemRunning,
      );
    }
  }

  Future<void> _executeSetParameterStep(RecipeStep step, Function(String, ComponentStatus) logCallback) async {
    String componentName = step.parameters['component'] as String;
    String parameterName = step.parameters['parameter'] as String;
    double value = step.parameters['value'] as double;

    if (_componentProvider.getComponent(componentName) != null) {
      _componentProvider.updateComponentSetValues(componentName, {parameterName: value});
      logCallback('Set $parameterName of $componentName to $value', ComponentStatus.normal);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _setReactionChamberParameters(
    double temperature,
    double pressure,
    Function(String, ComponentStatus) logCallback,
  ) async {
    _componentProvider.updateComponentSetValues('Reaction Chamber', {
      'temperature': temperature,
      'pressure': pressure,
    });
    logCallback(
      'Setting chamber temperature to $temperature°C and pressure to $pressure atm',
      ComponentStatus.normal
    );

    await Future.delayed(const Duration(seconds: 5));

    _componentProvider.updateComponentCurrentValues('Reaction Chamber', {
      'temperature': temperature,
      'pressure': pressure,
    });
    logCallback('Chamber reached target temperature and pressure', ComponentStatus.normal);
  }
}
