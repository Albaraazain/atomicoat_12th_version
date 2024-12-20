// lib/presentation/widgets/monitoring/alerts/alert_details_dialog.dart
import 'package:experiment_planner/domain/entities/alert/system_alert.dart';
import 'package:experiment_planner/presentation/bloc/alert/alert_bloc.dart';
import 'package:experiment_planner/presentation/bloc/alert/alert_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/alert/abstract_alert.dart';
import '../../../../domain/entities/alert/monitoring_alert.dart';
import '../../alert/alert_display_utils.dart';

class AlertDetailsDialog extends StatelessWidget with AlertDisplayUtils {
  final AbstractAlert alert;

  const AlertDetailsDialog({
    Key? key,
    required this.alert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Divider(),
            _buildDetails(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          getAlertIcon(alert.severity),
          color: getAlertColor(alert.severity),
          size: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alert Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                alert.severity.toString().split('.').last.toUpperCase(),
                style: TextStyle(
                  color: getAlertColor(alert.severity),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    final List<Widget> details = [
      _buildDetailRow('Component', alert.componentId ?? 'Unknown'),
      _buildDetailRow('Message', alert.message),
      _buildDetailRow('Time', formatDateTime(alert.timestamp)),  // Changed from _formatDateTime
    ];

    if (alert is MonitoringAlert) {
      final monitoringAlert = alert as MonitoringAlert;
      if (monitoringAlert.currentValue != null) {
        details.add(_buildDetailRow(
          'Current Value',
          '${monitoringAlert.currentValue} ${monitoringAlert.unit ?? ''}',
        ));
      }
      if (monitoringAlert.thresholdValue != null) {
        details.add(_buildDetailRow(
          'Threshold',
          '${monitoringAlert.thresholdValue} ${monitoringAlert.unit ?? ''}',
        ));
      }
    }

    if (alert is SystemAlert) {
      final systemAlert = alert as SystemAlert;
      if (systemAlert.acknowledgedBy != null) {
        details.add(_buildDetailRow('Acknowledged By', systemAlert.acknowledgedBy!));
      }
      if (systemAlert.acknowledgedAt != null) {
        details.add(_buildDetailRow(
          'Acknowledged At',
          formatDateTime(systemAlert.acknowledgedAt!),  // Changed from _formatDateTime
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (alert is! SystemAlert) return const SizedBox.shrink();

    final systemAlert = alert as SystemAlert;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          icon: Icon(
            systemAlert.isMuted ? Icons.volume_off : Icons.volume_up,
          ),
          label: Text(systemAlert.isMuted ? 'Unmute' : 'Mute'),
          onPressed: () => context.read<AlertBloc>().add(
                ToggleAlertMute(alertId: alert.id),
              ),
        ),
        if (!systemAlert.isAcknowledged) ...[
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Acknowledge'),
            onPressed: () {
              context.read<AlertBloc>().add(
                    AcknowledgeAlert(alertId: alert.id),
                  );
              Navigator.of(context).pop();
            },
          ),
        ],
      ],
    );
  }
  // ... Helper methods from previous implementations ...
}