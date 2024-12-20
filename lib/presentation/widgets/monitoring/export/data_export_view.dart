// lib/presentation/widgets/monitoring/export/data_export_view.dart
import 'package:experiment_planner/domain/services/data_export/data_exporter.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../domain/entities/machine/parameter.dart';
import '../../../../domain/models/session/session.dart';

class DataExportView extends StatefulWidget {
  final Session session;
  final List<Parameter> parameters;

  const DataExportView({
    Key? key,
    required this.session,
    required this.parameters,
  }) : super(key: key);

  @override
  State<DataExportView> createState() => _DataExportViewState();
}

class _DataExportViewState extends State<DataExportView> {
  late List<bool> _selectedParameters;
  ExportFormat _selectedFormat = ExportFormat.csv;
  bool _includeMetadata = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _selectedParameters = List.generate(
      widget.parameters.length,
      (_) => true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildParameterSelection(),
            const SizedBox(height: 16),
            _buildExportOptions(),
            const SizedBox(height: 16),
            _buildExportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.download),
        const SizedBox(width: 8),
        Text(
          'Export Session Data',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildParameterSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Select Parameters',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            TextButton(
              onPressed: _selectAll,
              child: const Text('Select All'),
            ),
            TextButton(
              onPressed: _deselectAll,
              child: const Text('Deselect All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            widget.parameters.length,
            (index) => FilterChip(
              label: Text(widget.parameters[index].name),
              selected: _selectedParameters[index],
              onSelected: (selected) {
                setState(() {
                  _selectedParameters[index] = selected;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExportOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Options',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<ExportFormat>(
                value: _selectedFormat,
                decoration: const InputDecoration(
                  labelText: 'Format',
                ),
                items: ExportFormat.values.map((format) {
                  return DropdownMenuItem(
                    value: format,
                    child: Text(format.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (format) {
                  if (format != null) {
                    setState(() {
                      _selectedFormat = format;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Include Metadata'),
                value: _includeMetadata,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _includeMetadata = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExportButton() {
    return Center(
      child: _isExporting
          ? const CircularProgressIndicator()
          : ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Export Data'),
              onPressed: _selectedParameters.contains(true)
                  ? _exportData
                  : null,
            ),
    );
  }

  void _selectAll() {
    setState(() {
      _selectedParameters.fillRange(0, _selectedParameters.length, true);
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedParameters.fillRange(0, _selectedParameters.length, false);
    });
  }

  Future<void> _exportData() async {
    setState(() {
      _isExporting = true;
    });

    try {
      final selectedParams = widget.parameters
          .where((param) => _selectedParameters[widget.parameters.indexOf(param)])
          .toList();

      final exporter = DataExporter(
        session: widget.session,
        parameters: selectedParams,
        format: _selectedFormat,
        includeMetadata: _includeMetadata,
      );

      final file = await exporter.export();

      setState(() {
        _isExporting = false;
      });

      // Show success dialog with file path
      _showExportSuccessDialog(file.path);
    } catch (e) {
      setState(() {
        _isExporting = false;
      });

      // Show error dialog
      _showExportErrorDialog(e.toString());
    }
  }

  void _showExportSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Data exported successfully to:'),
            const SizedBox(height: 8),
            Text(
              filePath,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () => _openExportedFile(filePath),
            child: const Text('Open File'),
          ),
        ],
      ),
    );
  }

  void _showExportErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _openExportedFile(String filePath) async {
    // Implement file opening logic
  }
}