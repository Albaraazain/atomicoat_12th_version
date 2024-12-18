import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:experiment_planner/features/alarm/bloc/alarm_bloc.dart';
import 'package:experiment_planner/features/alarm/bloc/alarm_state.dart';
import '../../../features/alarm/models/alarm.dart';

class AlarmIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmBloc, AlarmState>(
      builder: (context, state) {
        if (state is AlarmLoadSuccess) {
          return GestureDetector(
            onTap: () => _showAlarmDetails(context, state),
            child: Row(
              children: [
                Icon(
                  state.hasCriticalAlarm
                      ? Icons.error_outline
                      : state.hasActiveAlarms
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                  color: state.hasCriticalAlarm
                      ? Colors.red
                      : state.hasActiveAlarms
                          ? Colors.orange
                          : Colors.green,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  '${state.activeAlarms.length} Active Alarm${state.activeAlarms.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    color: state.hasCriticalAlarm
                        ? Colors.red
                        : state.hasActiveAlarms
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink(); // Return empty widget if state is not loaded
      },
    );
  }

  void _showAlarmDetails(BuildContext context, AlarmLoadSuccess state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Active Alarms'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.activeAlarms.map((alarm) => _buildAlarmItem(alarm)).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlarmItem(Alarm alarm) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            alarm.severity == AlarmSeverity.critical
                ? Icons.error_outline
                : Icons.warning_amber_rounded,
            color: alarm.severity == AlarmSeverity.critical
                ? Colors.red
                : Colors.orange,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(alarm.message),
          ),
        ],
      ),
    );
  }
}