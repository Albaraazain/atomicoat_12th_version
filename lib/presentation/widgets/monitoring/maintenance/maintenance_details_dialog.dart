// lib/presentation/widgets/monitoring/maintenance/maintenance_details_dialog.dart
import 'package:flutter/material.dart';

class MaintenanceDetailsDialog extends StatelessWidget {
  final MaintenanceRecord record;

  const MaintenanceDetailsDialog({
    Key? key,
    required this.record,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Maintenance Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            _buildDetailSection('Type', record.type.toString()),
            _buildDetailSection('Date', _formatDateTime(record.date)),
            _buildDetailSection('Duration', _formatDuration(record.duration)),
            _buildDetailSection('Performed By', record.performedBy),
            _buildDetailSection('Description', record.description),
            if (record.findings.isNotEmpty)
              _buildDetailSection('Findings', record.findings),
            if (record.recommendations.isNotEmpty)
              _buildDetailSection('Recommendations', record.recommendations),
            if (record.partsReplaced.isNotEmpty) _buildPartsReplacedSection(),
            if (record.attachments.isNotEmpty) _buildAttachmentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }

  Widget _buildPartsReplacedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parts Replaced',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          ListView.builder(
            shrinkWrap: true,
            itemCount: record.partsReplaced.length,
            itemBuilder: (context, index) {
              final part = record.partsReplaced[index];
              return ListTile(
                dense: true,
                title: Text(part.name),
                subtitle: Text('Serial: ${part.serialNumber}'),
                trailing: Text('Qty: ${part.quantity}'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attachments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: record.attachments.map((attachment) {
              return Chip(
                avatar: Icon(_getAttachmentIcon(attachment.type)),
                label: Text(attachment.name),
                onDeleted: () => _openAttachment(attachment),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
  }

  IconData _getAttachmentIcon(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.video:
        return Icons.video_library;
      default:
        return Icons.attach_file;
    }
  }

  void _openAttachment(Attachment attachment) {
    // Implement attachment opening logic
  }
}