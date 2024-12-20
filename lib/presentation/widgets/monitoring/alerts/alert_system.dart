// lib/presentation/widgets/monitoring/alerts/alert_system.dart
import 'package:experiment_planner/domain/enums/alert_enums.dart';
import 'package:experiment_planner/presentation/bloc/alert/alert_bloc.dart';
import 'package:experiment_planner/presentation/bloc/alert/alert_event.dart';
import 'package:experiment_planner/presentation/bloc/alert/alert_state.dart';
import 'package:experiment_planner/presentation/widgets/monitoring/alerts/alert_details_dialog.dart';
import 'package:experiment_planner/presentation/widgets/monitoring/alerts/alert_history_filters_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/alert/abstract_alert.dart';
import '../../../../domain/entities/alert/system_alert.dart';
import '../../../../domain/entities/alert/monitoring_alert.dart';
import '../../alert/alert_display_utils.dart';

class AlertSystem extends StatelessWidget with AlertDisplayUtils {
  const AlertSystem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertBloc, AlertState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.activeAlerts.isNotEmpty)
              _buildActiveAlertsPanel(context, state.activeAlerts),
            _buildAlertHistory(context, state.alertHistory),
          ],
        );
      },
    );
  }

  Widget _buildActiveAlertsPanel(BuildContext context, List<AbstractAlert> activeAlerts) {
    return Card(
      color: Colors.red.shade900.withOpacity(0.7),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.warning_amber_rounded, color: Colors.white),
            title: Text(
              'Active Alerts (${activeAlerts.length})',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: TextButton.icon(
              icon: const Icon(Icons.volume_off, color: Colors.white),
              label: const Text('Mute All', style: TextStyle(color: Colors.white)),
              onPressed: () => context.read<AlertBloc>().add(MuteAllAlerts()),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activeAlerts.length,
            itemBuilder: (context, index) => _buildActiveAlertTile(
              context,
              activeAlerts[index],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAlertTile(BuildContext context, AbstractAlert alert) {
    final bool isSystemAlert = alert is SystemAlert;

    return ListTile(
      leading: Icon(
        getAlertIcon(alert.severity),  // Changed from _getAlertIcon
        color: getAlertColor(alert.severity),  // Changed from _getAlertColor
      ),
      title: Text(
        alert.message,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        '${alert.componentId} - ${_formatTimestamp(alert.timestamp)}',  // Changed from componentName to componentId
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSystemAlert) ...[
            IconButton(
              icon: Icon(
                (alert as SystemAlert).isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
              onPressed: () => context.read<AlertBloc>().add(
                    ToggleAlertMute(alertId: alert.id),
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              onPressed: () => context.read<AlertBloc>().add(
                    AcknowledgeAlert(alertId: alert.id),
                  ),
            ),
          ],
        ],
      ),
      onTap: () => _showAlertDetails(context, alert),
    );
  }

  Widget _buildAlertHistory(BuildContext context, List<AbstractAlert> alertHistory) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Alert History'),
            trailing: TextButton(
              onPressed: () => _showAlertHistoryFilters(context),
              child: const Text('Filter'),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alertHistory.length,
            itemBuilder: (context, index) => _buildHistoryAlertTile(
              context,
              alertHistory[index],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryAlertTile(BuildContext context, AbstractAlert alert) {
    final additionalInfo = alert is MonitoringAlert
        ? '${alert.currentValue}${alert.unit ?? ''}'
        : '';

    return ListTile(
      leading: Icon(
        getAlertIcon(alert.severity),  // Changed from _getAlertIcon
        color: getAlertColor(alert.severity),  // Changed from _getAlertColor
      ),
      title: Text(alert.message),
      subtitle: Text(
        '${alert.componentId} - ${_formatTimestamp(alert.timestamp)} $additionalInfo',
      ),
      trailing: Text(
        _formatDuration(DateTime.now().difference(alert.timestamp)),
        style: TextStyle(color: Colors.grey[600]),
      ),
      onTap: () => _showAlertDetails(context, alert),
    );
  }

  void _showAlertDetails(BuildContext context, AbstractAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDetailsDialog(alert: alert),
    );
  }

  void _showAlertHistoryFilters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertHistoryFiltersDialog(),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    }
    return 'just now';
  }
}