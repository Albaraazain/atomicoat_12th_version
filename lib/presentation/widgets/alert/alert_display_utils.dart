import 'package:flutter/material.dart';
import '../../../../domain/enums/alert_enums.dart';
import 'package:intl/intl.dart';  // Add this import

mixin AlertDisplayUtils {
  IconData getAlertIcon(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Icons.error_outline;
      case AlertSeverity.high:
        return Icons.warning_amber_rounded;
      case AlertSeverity.medium:
        return Icons.info_outline;
      case AlertSeverity.low:
        return Icons.notifications_none;
    }
  }

  Color getAlertColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Colors.red;
      case AlertSeverity.high:
        return Colors.orange;
      case AlertSeverity.medium:
        return Colors.yellow;
      case AlertSeverity.low:
        return Colors.blue;
    }
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }
}
