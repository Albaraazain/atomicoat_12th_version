// lib/presentation/widgets/monitoring/maintenance/maintenance_info_view.dart
import 'package:flutter/material.dart';
import '../../../../domain/entities/maintenance/maintenance_record.dart';
import '../../../../domain/entities/machine/component.dart';

class MaintenanceInfoView extends StatelessWidget {
  final Component component;
  final List<MaintenanceRecord> maintenanceHistory;

  const MaintenanceInfoView({
    Key? key,
    required this.component,
    required this.maintenanceHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMaintenanceStatus(),
        const SizedBox(height: 16),
        _buildNextMaintenanceCard(),
        const SizedBox(height: 16),
        _buildMaintenanceHistory(),
      ],
    );
  }

  Widget _buildMaintenanceStatus() {
    final daysUntilMaintenance = component.getNextMaintenanceDue();
    final isMaintenanceRequired = daysUntilMaintenance <= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isMaintenanceRequired
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle,
                  color: isMaintenanceRequired ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  'Maintenance Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isMaintenanceRequired
                  ? 'Maintenance Required'
                  : 'Next maintenance in $daysUntilMaintenance days',
              style: TextStyle(
                color: isMaintenanceRequired ? Colors.orange : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextMaintenanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Next Maintenance Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...component.maintenanceTasks.map((task) => _buildTaskItem(task)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(MaintenanceTask task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            _getTaskIcon(task.type),
            size: 20,
            color: _getTaskColor(task.priority),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDueDate(task.dueDate),
            style: TextStyle(
              fontSize: 12,
              color: _getDueDateColor(task.dueDate),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceHistory() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Maintenance History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: maintenanceHistory.length,
            itemBuilder: (context, index) {
              final record = maintenanceHistory[index];
              return _buildMaintenanceRecordTile(record);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceRecordTile(MaintenanceRecord record) {
    return ListTile(
      leading: Icon(
        Icons.build,
        color: _getMaintenanceTypeColor(record.type),
      ),
      title: Text(record.description),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performed by: ${record.performedBy}',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Duration: ${record.duration.inHours}h ${record.duration.inMinutes % 60}m',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      trailing: Text(
        _formatDate(record.date),
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () => _showMaintenanceDetails(context, record),
    );
  }

  IconData _getTaskIcon(MaintenanceTaskType type) {
    switch (type) {
      case MaintenanceTaskType.inspection:
        return Icons.visibility;
      case MaintenanceTaskType.cleaning:
        return Icons.cleaning_services;
      case MaintenanceTaskType.calibration:
        return Icons.settings_backup_restore;
      case MaintenanceTaskType.replacement:
        return Icons.swap_horiz;
      default:
        return Icons.build;
    }
  }

  Color _getTaskColor(MaintenanceTaskPriority priority) {
    switch (priority) {
      case MaintenanceTaskPriority.high:
        return Colors.red;
      case MaintenanceTaskPriority.medium:
        return Colors.orange;
      case MaintenanceTaskPriority.low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getDueDateColor(DateTime dueDate) {
    final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
    if (daysUntilDue < 0) return Colors.red;
    if (daysUntilDue < 7) return Colors.orange;
    return Colors.green;
  }

  Color _getMaintenanceTypeColor(MaintenanceType type) {
    switch (type) {
      case MaintenanceType.preventive:
        return Colors.blue;
      case MaintenanceType.corrective:
        return Colors.orange;
      case MaintenanceType.predictive:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
    if (daysUntilDue < 0) return 'Overdue';
    if (daysUntilDue == 0) return 'Due today';
    return 'Due in $daysUntilDue days';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showMaintenanceDetails(BuildContext context, MaintenanceRecord record) {
    showDialog(
      context: context,
      builder: (context) => MaintenanceDetailsDialog(record: record),
    );
  }
}