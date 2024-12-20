// lib/presentation/widgets/monitoring/system_status_overlay.dart
import 'package:experiment_planner/domain/entities/machine/machine.dart';
import 'package:experiment_planner/domain/entities/alert/abstract_alert.dart';  // Updated import
import 'package:experiment_planner/domain/enums/machine_enums.dart';
import 'package:flutter/material.dart';

class SystemStatusOverlay extends StatelessWidget {
  final Machine machine;
  final List<AbstractAlert> alerts;  // Updated type

  const SystemStatusOverlay({
    Key? key,
    required this.machine,
    required this.alerts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(machine.status),
                color: _getStatusColor(machine.status),
              ),
              const SizedBox(width: 8),
              Text(
                machine.status.toString().split('.').last,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          if (alerts.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '${alerts.length} Active Alerts',
              style: TextStyle(
                color: Colors.red[300],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getStatusIcon(MachineStatus status) {
    switch (status) {
      case MachineStatus.idle:
        return Icons.check_circle;
      case MachineStatus.running:
        return Icons.play_circle;
      case MachineStatus.error:
        return Icons.error;
      case MachineStatus.maintenance:
        return Icons.build;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(MachineStatus status) {
    switch (status) {
      case MachineStatus.idle:
        return Colors.green;
      case MachineStatus.running:
        return Colors.blue;
      case MachineStatus.error:
        return Colors.red;
      case MachineStatus.maintenance:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
