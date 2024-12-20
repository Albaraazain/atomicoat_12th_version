import 'package:flutter/material.dart';
import '../../../../domain/enums/alert_enums.dart';

class AlertHistoryFiltersDialog extends StatefulWidget {
  const AlertHistoryFiltersDialog({Key? key}) : super(key: key);

  @override
  State<AlertHistoryFiltersDialog> createState() => _AlertHistoryFiltersDialogState();
}

class _AlertHistoryFiltersDialogState extends State<AlertHistoryFiltersDialog> {
  final Set<AlertSeverity> _selectedSeverities = {};
  DateTimeRange? _dateRange;
  String? _selectedComponent;

  final List<String> _components = [
    'Reactor',
    'Pump',
    'Sensor',
    'Controller',
    'Valve',
    // Add more components as needed
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Alert History'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSeverityFilter(),
            const SizedBox(height: 16),
            _buildDateRangeFilter(),
            const SizedBox(height: 16),
            _buildComponentFilter(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'severities': _selectedSeverities.toList(),
              'dateRange': _dateRange,
              'component': _selectedComponent,
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildSeverityFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Severity',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: AlertSeverity.values.map((severity) {
            return FilterChip(
              selected: _selectedSeverities.contains(severity),
              label: Text(severity.toString().split('.').last),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSeverities.add(severity);
                  } else {
                    _selectedSeverities.remove(severity);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date Range',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            _dateRange != null
                ? '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}'
                : 'Select date range',
          ),
          trailing: _dateRange != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _dateRange = null),
                )
              : null,
          onTap: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
              initialDateRange: _dateRange,
            );
            if (picked != null) {
              setState(() => _dateRange = picked);
            }
          },
        ),
      ],
    );
  }

  Widget _buildComponentFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Component',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedComponent,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('All Components'),
            ),
            ..._components.map(
              (component) => DropdownMenuItem(
                value: component,
                child: Text(component),
              ),
            ),
          ],
          onChanged: (value) => setState(() => _selectedComponent = value),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
