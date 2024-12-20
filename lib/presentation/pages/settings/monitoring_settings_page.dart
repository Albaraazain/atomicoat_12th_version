// lib/presentation/pages/settings/monitoring_settings_page.dart
import 'package:experiment_planner/presentation/widgets/monitoring/monitoring_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonitoringSettingsPage extends StatefulWidget {
  @override
  State<MonitoringSettingsPage> createState() => _MonitoringSettingsPageState();
}

class _MonitoringSettingsPageState extends State<MonitoringSettingsPage> {
  late MonitoringConfig _config;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final config = await context.read<MonitoringBloc>().loadConfig();
      setState(() {
        _config = config;
        _isLoading = false;
      });
    } catch (e) {
      _showError('Failed to load monitoring configuration');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Settings'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _saveConfig,
              child: const Text('Save'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        onWillPop: _onWillPop,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildGeneralSettings(),
            const Divider(),
            _buildParameterSettings(),
            const Divider(),
            _buildAlertSettings(),
            const Divider(),
            _buildDataCollectionSettings(),
            const Divider(),
            _buildDisplaySettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Auto Reconnect'),
              subtitle: const Text('Automatically reconnect when connection is lost'),
              value: _config.autoReconnect,
              onChanged: (value) {
                setState(() {
                  _config = MonitoringConfig(
                    parameters: _config.parameters,
                    alertConfig: _config.alertConfig,
                    dataCollection: _config.dataCollection,
                    displayConfig: _config.displayConfig,
                    autoReconnect: value,
                    updateInterval: _config.updateInterval,
                    maxDataPoints: _config.maxDataPoints,
                  );
                  _hasChanges = true;
                });
              },
            ),
            ListTile(
              title: const Text('Update Interval'),
              subtitle: Text('${_config.updateInterval.inMilliseconds}ms'),
              trailing: DropdownButton<Duration>(
                value: _config.updateInterval,
                items: [
                  DropdownMenuItem(
                    value: const Duration(milliseconds: 100),
                    child: const Text('100ms'),
                  ),
                  DropdownMenuItem(
                    value: const Duration(milliseconds: 250),
                    child: const Text('250ms'),
                  ),
                  DropdownMenuItem(
                    value: const Duration(milliseconds: 500),
                    child: const Text('500ms'),
                  ),
                  DropdownMenuItem(
                    value: const Duration(seconds: 1),
                    child: const Text('1s'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _config = MonitoringConfig(
                        parameters: _config.parameters,
                        alertConfig: _config.alertConfig,
                        dataCollection: _config.dataCollection,
                        displayConfig: _config.displayConfig,
                        autoReconnect: _config.autoReconnect,
                        updateInterval: value,
                        maxDataPoints: _config.maxDataPoints,
                      );
                      _hasChanges = true;
                    });
                  }
                },
              ),
            ),
            TextFormField(
              initialValue: _config.maxDataPoints.toString(),
              decoration: const InputDecoration(
                labelText: 'Maximum Data Points',
                helperText: 'Number of data points to keep in memory',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final number = int.tryParse(value);
                if (number == null || number < 100) {
                  return 'Please enter a valid number (min: 100)';
                }
                return null;
              },
              onChanged: (value) {
                final number = int.tryParse(value);
                if (number != null && number >= 100) {
                  setState(() {
                    _config = MonitoringConfig(
                      parameters: _config.parameters,
                      alertConfig: _config.alertConfig,
                      dataCollection: _config.dataCollection,
                      displayConfig: _config.displayConfig,
                      autoReconnect: _config.autoReconnect,
                      updateInterval: _config.updateInterval,
                      maxDataPoints: number,
                    );
                    _hasChanges = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterSettings() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Parameter Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addParameter,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _config.parameters.length,
            itemBuilder: (context, index) {
              final parameter = _config.parameters.entries.elementAt(index);
              return _buildParameterConfigTile(parameter.key, parameter.value);
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildParameterConfigTile(String parameterId, ParameterConfig config) {
  return ExpansionTile(
    title: Text(parameterId),
    subtitle: Text(config.enabled ? 'Enabled' : 'Disabled'),
    children: [
      SwitchListTile(
        title: const Text('Enable Monitoring'),
        value: config.enabled,
        onChanged: (value) => _updateParameterConfig(
          parameterId,
          config.copyWith(enabled: value),
        ),
      ),
      ListTile(
        title: const Text('Warning Threshold'),
        trailing: SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: config.warningThreshold?.toString() ?? '',
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            onChanged: (value) {
              final threshold = double.tryParse(value);
              _updateParameterConfig(
                parameterId,
                config.copyWith(warningThreshold: threshold),
              );
            },
          ),
        ),
      ),
      // Add more parameter-specific settings...
    ],
  );
}
