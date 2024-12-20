// lib/presentation/widgets/recording/recording_controls.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class RecordingControls extends StatelessWidget {
  final DataRecorder recorder;

  const RecordingControls({
    Key? key,
    required this.recorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RecordingStatus>(
      stream: recorder.status,
      builder: (context, snapshot) {
        final isRecording = snapshot.data?.isRecording ?? false;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recording',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (isRecording)
                      _buildRecordingIndicator(snapshot.data!),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(isRecording ? Icons.stop : Icons.fiber_manual_record),
                      label: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRecording ? Colors.red : Colors.green,
                      ),
                      onPressed: () {
                        if (isRecording) {
                          recorder.stopRecording();
                        } else {
                          recorder.startRecording();
                        }
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.folder_open),
                      label: const Text('View Recordings'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordingsListPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecordingIndicator(RecordingStatus status) {
    final duration = DateTime.now().difference(status.startTime);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatDuration(duration),
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
