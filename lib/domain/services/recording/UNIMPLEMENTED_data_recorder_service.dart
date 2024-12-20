// lib/domain/services/recording/data_recorder.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:experiment_planner/presentation/widgets/monitoring/monitoring_config.dart';

class DataRecorder {
  final String sessionId;
  final MonitoringConfig config;
  final Directory recordingDirectory;

  bool _isRecording = false;
  late File _dataFile;
  late File _metadataFile;
  late IOSink _dataSink;

  final _recordingController = StreamController<RecordingStatus>.broadcast();

  DataRecorder({
    required this.sessionId,
    required this.config,
    required this.recordingDirectory,
  });

  Stream<RecordingStatus> get status => _recordingController.stream;

  Future<void> startRecording() async {
    if (_isRecording) return;

    try {
      // Create recording directory if it doesn't exist
      if (!await recordingDirectory.exists()) {
        await recordingDirectory.create(recursive: true);
      }

      // Initialize files
      _dataFile = File('${recordingDirectory.path}/data_$sessionId.csv');
      _metadataFile = File('${recordingDirectory.path}/metadata_$sessionId.json');

      // Write metadata
      await _metadataFile.writeAsString(jsonEncode({
        'sessionId': sessionId,
        'startTime': DateTime.now().toIso8601String(),
        'config': config.toJson(),
      }));

      // Open data file for writing
      _dataSink = _dataFile.openWrite();

      // Write header
      final headers = ['timestamp', ...config.parameters.keys];
      await _dataSink.writeln(headers.join(','));

      _isRecording = true;
      _recordingController.add(RecordingStatus(
        isRecording: true,
        sessionId: sessionId,
        startTime: DateTime.now(),
      ));
    } catch (e) {
      throw RecordingException('Failed to start recording: $e');
    }
  }

  Future<void> recordData(Map<String, double> values) async {
    if (!_isRecording) return;

    try {
      final timestamp = DateTime.now().toIso8601String();
      final dataRow = [timestamp];

      for (final parameter in config.parameters.keys) {
        dataRow.add(values[parameter]?.toString() ?? '');
      }

      await _dataSink.writeln(dataRow.join(','));
    } catch (e) {
      throw RecordingException('Failed to record data: $e');
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    try {
      await _dataSink.close();

      // Update metadata with end time
      final metadata = jsonDecode(await _metadataFile.readAsString());
      metadata['endTime'] = DateTime.now().toIso8601String();
      await _metadataFile.writeAsString(jsonEncode(metadata));

      _isRecording = false;
      _recordingController.add(RecordingStatus(
        isRecording: false,
        sessionId: sessionId,
        startTime: DateTime.parse(metadata['startTime']),
        endTime: DateTime.now(),
      ));
    } catch (e) {
      throw RecordingException('Failed to stop recording: $e');
    }
  }

  Future<RecordingMetadata> getMetadata() async {
    if (!await _metadataFile.exists()) {
      throw RecordingException('Recording metadata not found');
    }

    try {
      final metadata = jsonDecode(await _metadataFile.readAsString());
      return RecordingMetadata.fromJson(metadata);
    } catch (e) {
      throw RecordingException('Failed to read recording metadata: $e');
    }
  }
}
