import '../models/system_component.dart';
import '../providers/system_copmonent_provider.dart';

class SystemValidationService {
  final SystemComponentProvider _componentProvider;
  final double _tolerance = 0.1; // 10% tolerance

  SystemValidationService(this._componentProvider);

  List<String> getSystemIssues() {
    List<String> issues = [];

    _checkNitrogenFlow(issues);
    _checkMFC(issues);
    _checkPressure(issues);
    _checkPump(issues);
    _checkHeaters(issues);
    _checkValueMismatches(issues);

    return issues;
  }

  void _checkNitrogenFlow(List<String> issues) {
    final nitrogenGenerator = _componentProvider.getComponent('Nitrogen Generator');
    if (nitrogenGenerator != null) {
      if (!nitrogenGenerator.isActivated) {
        issues.add('Nitrogen Generator is not activated');
      } else if (nitrogenGenerator.currentValues['flow_rate']! < 10.0) {
        issues.add(
            'Nitrogen flow rate is too low (current: ${nitrogenGenerator.currentValues['flow_rate']!.toStringAsFixed(1)}, required: ≥10.0)');
      }
    }
  }

  void _checkMFC(List<String> issues) {
    final mfc = _componentProvider.getComponent('MFC');
    if (mfc != null) {
      if (!mfc.isActivated) {
        issues.add('MFC is not activated');
      } else if (mfc.currentValues['flow_rate']! != 20.0) {
        issues.add(
            'MFC flow rate needs adjustment (current: ${mfc.currentValues['flow_rate']!.toStringAsFixed(1)}, required: 20.0)');
      }
    }
  }

  void _checkPressure(List<String> issues) {
    final pressureControlSystem = _componentProvider.getComponent('Pressure Control System');
    if (pressureControlSystem != null) {
      if (!pressureControlSystem.isActivated) {
        issues.add('Pressure Control System is not activated');
      } else if (pressureControlSystem.currentValues['pressure']! >= 760.0) {
        issues.add(
            'Pressure is too high (current: ${pressureControlSystem.currentValues['pressure']!.toStringAsFixed(1)}, must be <760.0)');
      }
    }
  }

  void _checkPump(List<String> issues) {
    final pump = _componentProvider.getComponent('Vacuum Pump');
    if (pump != null) {
      if (!pump.isActivated) {
        issues.add('Vacuum Pump is not activated');
      }
    }
  }

  void _checkHeaters(List<String> issues) {
    final heaters = [
      'Precursor Heater 1',
      'Precursor Heater 2',
      'Frontline Heater',
      'Backline Heater'
    ];
    for (var heaterName in heaters) {
      final heater = _componentProvider.getComponent(heaterName);
      if (heater != null && !heater.isActivated) {
        issues.add('$heaterName is not activated');
      }
    }
  }

  void _checkValueMismatches(List<String> issues) {
    for (var component in _componentProvider.components.values) {
      for (var entry in component.currentValues.entries) {
        final setValue = component.setValues[entry.key] ?? 0.0;
        if (setValue != entry.value) {
          issues.add(
              '${component.name}: ${entry.key} mismatch (current: ${entry.value.toStringAsFixed(1)}, set: ${setValue.toStringAsFixed(1)})');
        }
      }
    }
  }

  bool checkSystemReadiness() {
    bool isReady = true;
    List<String> issues = [];

    // Check Nitrogen Flow
    final nitrogenGenerator = _componentProvider.getComponent('Nitrogen Generator');
    if (nitrogenGenerator != null) {
      if (!nitrogenGenerator.isActivated) {
        isReady = false;
        issues.add('Nitrogen Generator is not activated');
      } else if (nitrogenGenerator.currentValues['flow_rate']! < 10.0) {
        isReady = false;
        issues.add('Nitrogen flow rate is too low');
      }
    }

    // Check MFC
    final mfc = _componentProvider.getComponent('MFC');
    if (mfc != null) {
      if (!mfc.isActivated) {
        isReady = false;
        issues.add('MFC is not activated');
      } else if (mfc.currentValues['flow_rate']! < 15.0 ||
          mfc.currentValues['flow_rate']! > 25.0) {
        isReady = false;
        issues.add('MFC flow rate is outside acceptable range (15-25 SCCM)');
      }
    }

    // Check Pressure
    final pressureControlSystem = _componentProvider.getComponent('Pressure Control System');
    if (pressureControlSystem != null) {
      if (!pressureControlSystem.isActivated) {
        isReady = false;
        issues.add('Pressure Control System is not activated');
      } else if (pressureControlSystem.currentValues['pressure']! > 10.0) {
        isReady = false;
        issues.add('Pressure is too high (must be below 10 Torr)');
      }
    }

    // Check Pump and Heaters
    _checkPump(issues);
    _checkHeaters(issues);

    return isReady;
  }

  bool validateSetVsMonitoredValues() {
    bool isValid = true;

    for (var component in _componentProvider.components.values) {
      for (var entry in component.currentValues.entries) {
        final setValue = component.setValues[entry.key] ?? 0.0;
        final currentValue = entry.value;

        // Skip validation for certain parameters
        if (entry.key == 'status') continue;

        // Check if the current value is within tolerance of set value
        if (setValue == 0.0) {
          if (currentValue > _tolerance) {
            isValid = false;
            break;
          }
        } else {
          final percentDiff = (currentValue - setValue).abs() / setValue;
          if (percentDiff > _tolerance) {
            isValid = false;
            break;
          }
        }
      }
      if (!isValid) break;
    }
    return isValid;
  }

  bool isReactorPressureNormal() {
    final pressure = _componentProvider
            .getComponent('Reaction Chamber')
            ?.currentValues['pressure'] ??
        0.0;
    return pressure >= 0.9 && pressure <= 1.1;
  }

  bool isReactorTemperatureNormal() {
    final temperature = _componentProvider
            .getComponent('Reaction Chamber')
            ?.currentValues['temperature'] ??
        0.0;
    return temperature >= 145 && temperature <= 155;
  }

  bool isPrecursorTemperatureNormal(String precursor) {
    final component = _componentProvider.getComponent(precursor);
    if (component != null) {
      final temperature = component.currentValues['temperature'] ?? 0.0;
      return temperature >= 28 && temperature <= 32;
    }
    return false;
  }
}
