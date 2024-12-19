import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../services/auth_service.dart';
import '../../../features/alarm/models/alarm.dart';
import '../../../features/alarm/bloc/alarm_state.dart';
import '../models/recipe.dart';
import '../models/safety_error.dart';
import '../models/system_component.dart';
import '../models/system_log_entry.dart';
import '../models/data_point.dart';
import '../services/ald_system_simulation_service.dart';
import '../services/alarm_handling_service.dart';
import '../services/component_initialization_service.dart';
import '../services/recipe_execution_service.dart';
import '../services/system_logging_service.dart';
import '../services/system_validation_service.dart';
import 'recipe_provider.dart';
import 'system_copmonent_provider.dart';

class SystemStateProvider extends ChangeNotifier {
  final SystemComponentProvider _componentProvider;
  final AuthService _authService;
  final SystemLoggingService _loggingService;
  final SystemValidationService _validationService;
  final RecipeExecutionService _recipeExecutionService;
  final AlarmHandlingService _alarmService;

  Recipe? _activeRecipe;
  int _currentRecipeStepIndex = 0;
  Recipe? _selectedRecipe;
  bool _isSystemRunning = false;
  late AldSystemSimulationService _simulationService;
  late RecipeProvider _recipeProvider;
  Timer? _stateUpdateTimer;

  // Constructor with required dependencies
  SystemStateProvider(
    this._componentProvider,
    this._authService,
    this._loggingService,
    this._validationService,
    this._recipeExecutionService,
    this._alarmService,
    this._recipeProvider,
  ) {
    _initializeComponents();
    _loadSystemLog();
    _simulationService = AldSystemSimulationService(systemStateProvider: this);
  }

  // Getters
  Recipe? get activeRecipe => _activeRecipe;
  int get currentRecipeStepIndex => _currentRecipeStepIndex;
  Recipe? get selectedRecipe => _selectedRecipe;
  bool get isSystemRunning => _isSystemRunning;
  List<SystemLogEntry> get systemLog => _loggingService.systemLog;
  List<Alarm> get activeAlarms => _alarmService.getActiveAlarms();
  Map<String, SystemComponent> get components => _componentProvider.components;

  void _initializeComponents() {
    final components = ComponentInitializationService.getInitialComponents();
    for (var component in components) {
      _componentProvider.addComponent(component);
    }
    notifyListeners();
  }

  Future<void> _loadSystemLog() async {
    String? userId = _authService.currentUser?.uid;
    if (userId != null) {
      await _loggingService.loadSystemLog(userId);
      notifyListeners();
    }
  }

  List<String> getSystemIssues() => _validationService.getSystemIssues();

  void batchUpdateComponentValues(Map<String, Map<String, double>> updates) {
    updates.forEach((componentName, newStates) {
      _componentProvider.updateComponentCurrentValues(componentName, newStates);
    });
    notifyListeners();
  }

  bool checkSystemReadiness() {
    bool isReady = _validationService.checkSystemReadiness();
    if (!isReady) {
      String? userId = _authService.currentUserId;
      if (userId != null) {
        _alarmService.addAlarm(userId, 'System not ready to start. Check system readiness.', AlarmSeverity.warning);
      }
    }
    return isReady;
  }

  void startSystem() {
    if (!_isSystemRunning && checkSystemReadiness()) {
      _isSystemRunning = true;
      _simulationService.startSimulation();
      _startContinuousStateLogging();
      _logSystemEvent('System started', ComponentStatus.normal);
      notifyListeners();
    }
  }

  void stopSystem() {
    _isSystemRunning = false;
    _activeRecipe = null;
    _currentRecipeStepIndex = 0;
    _simulationService.stopSimulation();
    _stopContinuousStateLogging();
    _deactivateAllValves();
    _logSystemEvent('System stopped', ComponentStatus.normal);
    notifyListeners();
  }

  void _startContinuousStateLogging() {
    _stateUpdateTimer = Timer.periodic(Duration(seconds: 5), (_) {
      _saveCurrentState();
    });
  }

  void _stopContinuousStateLogging() {
    _stateUpdateTimer?.cancel();
    _stateUpdateTimer = null;
  }

  void _saveCurrentState() {
    String? userId = _authService.currentUserId;
    if (userId == null) return;

    for (var component in _componentProvider.components.values) {
      _loggingService.saveComponentState(userId, component);
    }

    _loggingService.saveSystemState(userId, {
      'isRunning': _isSystemRunning,
      'activeRecipeId': _activeRecipe?.id,
      'currentRecipeStepIndex': _currentRecipeStepIndex,
    });
  }

  void _deactivateAllValves() {
    _componentProvider.components.keys
        .where((name) => name.toLowerCase().contains('valve'))
        .forEach((valveName) {
      _componentProvider.deactivateComponent(valveName);
      _logSystemEvent('$valveName deactivated', ComponentStatus.normal);
    });
  }

  void _logSystemEvent(String message, ComponentStatus status) {
    String? userId = _authService.currentUserId;
    if (userId != null) {
      _loggingService.addLogEntry(userId, message, status);
      notifyListeners();
    }
  }

  Future<void> executeRecipe(Recipe recipe) async {
    if (_validationService.checkSystemReadiness()) {
      _activeRecipe = recipe;
      _currentRecipeStepIndex = 0;
      _isSystemRunning = true;
      _logSystemEvent('Executing recipe: ${recipe.name}', ComponentStatus.normal);
      _simulationService.startSimulation();
      notifyListeners();

      await _recipeExecutionService.executeSteps(
        recipe.steps,
        logCallback: _logSystemEvent,
        isSystemRunning: _isSystemRunning,
      );

      completeRecipe();
    } else {
      String? userId = _authService.currentUserId;
      if (userId != null) {
        _alarmService.addAlarm(userId, 'System not ready to start', AlarmSeverity.warning);
      }
    }
  }

  void selectRecipe(String id) {
    _selectedRecipe = _recipeProvider.getRecipeById(id);
    if (_selectedRecipe != null) {
      _logSystemEvent('Recipe selected: ${_selectedRecipe!.name}', ComponentStatus.normal);
    } else {
      String? userId = _authService.currentUserId;
      if (userId != null) {
        _alarmService.addAlarm(userId, 'Failed to select recipe: Recipe not found', AlarmSeverity.warning);
      }
    }
    notifyListeners();
  }

  void emergencyStop() {
    String? userId = _authService.currentUserId;
    if (userId == null) return;

    stopSystem();
    for (var component in _componentProvider.components.values) {
      if (component.isActivated) {
        _componentProvider.deactivateComponent(component.name);
        _loggingService.saveComponentState(userId, component);
      }
    }

    _alarmService.addAlarm(userId, 'Emergency stop activated', AlarmSeverity.critical);
    _logSystemEvent('Emergency stop activated', ComponentStatus.error);
    notifyListeners();
  }

  void incrementRecipeStepIndex() {
    if (_activeRecipe != null &&
        _currentRecipeStepIndex < _activeRecipe!.steps.length - 1) {
      _currentRecipeStepIndex++;
      notifyListeners();
    }
  }

  void completeRecipe() {
    _logSystemEvent('Recipe completed: ${_activeRecipe?.name}', ComponentStatus.normal);
    _activeRecipe = null;
    _currentRecipeStepIndex = 0;
    _isSystemRunning = false;
    _simulationService.stopSimulation();
    notifyListeners();
  }

  void triggerSafetyAlert(SafetyError error) {
    String? userId = _authService.currentUserId;
    if (userId != null) {
      _alarmService.triggerSafetyAlert(userId, error);
      _logSystemEvent('Safety Alert: ${error.description}', ComponentStatus.error);
    }
  }

  List<Recipe> getAllRecipes() => _recipeProvider.recipes;

  void refreshRecipes() {
    _recipeProvider.loadRecipes();
    notifyListeners();
  }

  // Component-related methods
  SystemComponent? getComponentByName(String componentName) {
    return _componentProvider.getComponent(componentName);
  }

  void updateComponentCurrentValues(String componentName, Map<String, double> newStates) {
    _componentProvider.updateComponentCurrentValues(componentName, newStates);
    notifyListeners();
  }

  // System validation methods
  bool isSystemReadyForRecipe() {
    return _validationService.checkSystemReadiness() &&
           _validationService.validateSetVsMonitoredValues();
  }

  bool isReactorPressureNormal() {
    return _validationService.isReactorPressureNormal();
  }

  bool isReactorTemperatureNormal() {
    return _validationService.isReactorTemperatureNormal();
  }

  bool isPrecursorTemperatureNormal(String precursor) {
    return _validationService.isPrecursorTemperatureNormal(precursor);
  }

  void runDiagnostic(String componentName) {
    _logSystemEvent('Running diagnostic for $componentName', ComponentStatus.normal);
    Future.delayed(const Duration(seconds: 2), () {
      _logSystemEvent('$componentName diagnostic completed: All systems nominal', ComponentStatus.normal);
      notifyListeners();
    });
  }

  void acknowledgeAlarm(String alarmId) {
    String? userId = _authService.currentUserId;
    if (userId != null) {
      _alarmService.acknowledgeAlarm(userId, alarmId);
      notifyListeners();
    }
  }

  void addAlarm(String message, AlarmSeverity severity) {
    String? userId = _authService.currentUserId;
    if (userId != null) {
      _alarmService.addAlarm(userId, message, severity);
      notifyListeners();
    }
  }

  void updateProviders(RecipeProvider recipeProvider) {
    _recipeProvider = recipeProvider;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopContinuousStateLogging();
    _simulationService.dispose();
    super.dispose();
  }
}