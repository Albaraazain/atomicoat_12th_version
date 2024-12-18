// lib/modules/system_operation_also_main_module/widgets/alarm_display.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/alarm/models/alarm.dart';
import '../providers/system_state_provider.dart';

class AlarmDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SystemStateProvider>(
      builder: (context, systemStateProvider, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Active Alarms',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: systemStateProvider.activeAlarms.isEmpty
                  ? Center(child: Text('No active alarms'))
                  : ListView.builder(
                itemCount: systemStateProvider.activeAlarms.length,
                itemBuilder: (context, index) {
                  final alarm = systemStateProvider.activeAlarms[index];
                  return Card(
                    child: ListTile(
                      leading: _getAlarmIcon(alarm.severity),
                      title: Text(alarm.message),
                      subtitle: Text(
                        '${alarm.timestamp.toString().split('.')[0]}',
                      ),
                      trailing: alarm.acknowledged
                          ? Icon(Icons.check, color: Colors.green)
                          : TextButton(
                        child: Text('Acknowledge'),
                        onPressed: () {
                          systemStateProvider.acknowledgeAlarm(alarm.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getAlarmIcon(AlarmSeverity severity) {
    switch (severity) {
      case AlarmSeverity.info:
        return Icon(Icons.info, color: Colors.blue);
      case AlarmSeverity.warning:
        return Icon(Icons.warning, color: Colors.orange);
      case AlarmSeverity.critical:
        return Icon(Icons.error, color: Colors.red);
    }
  }
}