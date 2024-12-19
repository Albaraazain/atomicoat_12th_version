import '../models/system_component.dart';

class ComponentInitializationService {
  static List<SystemComponent> getInitialComponents() {
    return [
      SystemComponent(
        name: 'Nitrogen Generator',
        description: 'Generates nitrogen gas for the system',
        isActivated: true,
        currentValues: {
          'flow_rate': 0.0,
          'purity': 99.9,
        },
        setValues: {
          'flow_rate': 50.0,
          'purity': 99.9,
        },
        lastCheckDate: DateTime.now().subtract(Duration(days: 30)),
        minValues: {
          'flow_rate': 10.0,
          'purity': 90.0,
        },
        maxValues: {
          'flow_rate': 100.0,
          'purity': 100.0,
        },
      ),
      SystemComponent(
        name: 'MFC',
        description: 'Mass Flow Controller for precursor gas',
        isActivated: true,
        currentValues: {
          'flow_rate': 20.0,
          'pressure': 1.0,
          'percent_correction': 0.0,
        },
        setValues: {
          'flow_rate': 50.0,
          'pressure': 1.0,
          'percent_correction': 0.0,
        },
        lastCheckDate: DateTime.now().subtract(Duration(days: 45)),
        minValues: {
          'flow_rate': 0.0,
          'pressure': 0.5,
          'percent_correction': -10.0,
        },
        maxValues: {
          'flow_rate': 100.0,
          'pressure': 2.0,
          'percent_correction': 10.0,
        },
      ),
      SystemComponent(
        name: 'Reaction Chamber',
        description: 'Main chamber for chemical reactions',
        isActivated: true,
        currentValues: {
          'temperature': 150.0,
          'pressure': 1.0,
        },
        setValues: {
          'temperature': 150.0,
          'pressure': 1.0,
        },
        lastCheckDate: DateTime.now().subtract(Duration(days: 60)),
        minValues: {
          'temperature': 100.0,
          'pressure': 0.8,
        },
        maxValues: {
          'temperature': 200.0,
          'pressure': 1.2,
        },
      ),
      // Add other components...
    ];
  }
}
