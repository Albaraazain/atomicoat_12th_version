import 'dart:async';
import 'dart:math';
import 'package:experiment_planner/features/alarm/models/alarm.dart';
import '../providers/system_state_provider.dart';

class AldSystemSimulationService {
  final SystemStateProvider systemStateProvider;
  Timer? _simulationTimer;
  final Random _random = Random();

  // Constants
  static const int SIMULATION_INTERVAL_MS = 500; // Increased from 100ms to 500ms
  static const double BASE_GROWTH_PER_CYCLE = 0.1; // nm per cycle
  static const double OPTIMAL_TEMPERATURE = 200.0; // °C
  static const double OPTIMAL_PRESSURE = 1.0; // atm

  // Define dependencies where certain components affect others
  final Map<String, List<String>> _dependencies = {
    'MFC': ['Nitrogen Generator'],
    'Pressure Control System': ['Reaction Chamber'],
  };

  AldSystemSimulationService({required this.systemStateProvider});

  void startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(milliseconds: SIMULATION_INTERVAL_MS), (_) => _simulateTick());
    systemStateProvider.addAlarm("ALD System Simulation started.", AlarmSeverity.info);
  }

  void stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    systemStateProvider.addAlarm("ALD System Simulation stopped.", AlarmSeverity.info);
  }

  void _simulateTick() {
    _updateComponentStates();
    _generateRandomErrors();
    _checkSafetyConditions();
  }

  void _checkSafetyConditions() {
    final reactionChamber = systemStateProvider.getComponentByName('Reaction Chamber');
    if (reactionChamber == null) {
      systemStateProvider.addAlarm("Error: Reaction Chamber not found!", AlarmSeverity.critical);
      return;
    }

    double chamberPressure = reactionChamber.currentValues['pressure'] ?? 0.0;
    double chamberTemperature = reactionChamber.currentValues['temperature'] ?? 0.0;

    if (chamberPressure > 10.0) {
      systemStateProvider.addAlarm("Chamber overpressure detected!", AlarmSeverity.critical);
    }

    if (chamberTemperature > 300.0) {
      systemStateProvider.addAlarm("Chamber overtemperature detected!", AlarmSeverity.critical);
    }
  }

  void _updateComponentStates() {
    Map<String, Map<String, double>> updates = {};

    for (var component in systemStateProvider.components.values) {
      if (!component.isActivated) continue;

      Map<String, double> componentUpdates = {};

      component.currentValues.forEach((parameter, value) {
        double newValue = _generateNewValue(component.name, parameter, value);
        componentUpdates[parameter] = newValue;
      });

      if (componentUpdates.isNotEmpty) {
        updates[component.name] = componentUpdates;
      }
    }

    systemStateProvider.batchUpdateComponentValues(updates);
    _applyDependencies(updates);
  }

  void _applyDependencies(Map<String, Map<String, double>> updates) {
    Map<String, Map<String, double>> dependencyUpdates = {};

    updates.forEach((componentName, newStates) {
      if (_dependencies.containsKey(componentName)) {
        for (var dependentName in _dependencies[componentName]!) {
          var dependentComponent = systemStateProvider.getComponentByName(dependentName);
          if (dependentComponent != null) {
            if (componentName == 'MFC' && newStates.containsKey('flow_rate')) {
              double mfcFlowRate = newStates['flow_rate']!;
              double adjustedFlowRate = _adjustDependentValue(mfcFlowRate, 0.8, 0.2);
              dependencyUpdates[dependentName] = {'flow_rate': adjustedFlowRate};
            }

            if (componentName == 'Pressure Control System' && newStates.containsKey('pressure')) {
              double pcsPressure = newStates['pressure']!;
              double adjustedPressure = _adjustDependentValue(pcsPressure, 0.9, 0.1);
              dependencyUpdates[dependentName] = {'pressure': adjustedPressure};
            }
          }
        }
      }
    });

    if (dependencyUpdates.isNotEmpty) {
      systemStateProvider.batchUpdateComponentValues(dependencyUpdates);
    }
  }

  double _adjustDependentValue(double baseValue, double factor, double fluctuation) {
    double adjustedValue = baseValue * factor + _random.nextDouble() * fluctuation * 2 - fluctuation;
    return adjustedValue.clamp(0.0, double.infinity);
  }

  void _generateRandomErrors() {
    for (var alarm in systemStateProvider.activeAlarms) {
      if (alarm.message.contains('Mass Flow Controller Malfunction')) {
        systemStateProvider.updateComponentCurrentValues('MFC', {'flow_rate': 0.0});
      }
    }
  }

  double _generateNewValue(String componentName, String parameter, double currentValue) {
    double fluctuationRange = _getFluctuationRange(parameter);
    double delta = (_random.nextDouble() * fluctuationRange * 2) - fluctuationRange;
    double setpoint = systemStateProvider.getComponentByName(componentName)?.setValues[parameter] ?? currentValue;
    double newValue = _moveTowards(currentValue, setpoint, step: 0.1) + delta;
    return _clampValue(componentName, parameter, newValue);
  }

  double _getFluctuationRange(String parameter) {
    switch (parameter) {
      case 'flow_rate': return 2.0;
      case 'temperature': return 5.0;
      case 'pressure': return 0.05;
      case 'power': return 1.0;
      case 'status': return 0.05;
      default: return 1.0;
    }
  }

  double _moveTowards(double current, double target, {required double step}) {
    return (current < target) ? (current + step).clamp(current, target) :
    (current > target) ? (current - step).clamp(target, current) :
    current;
  }

  double _clampValue(String componentName, String parameter, double value) {
    final component = systemStateProvider.getComponentByName(componentName);
    if (component == null) return value;

    double? minValue = component.minValues[parameter];
    double? maxValue = component.maxValues[parameter];

    if (minValue != null && value < minValue) return minValue;
    if (maxValue != null && value > maxValue) return maxValue;

    return value;
  }

  void dispose() {
    stopSimulation();
  }
}