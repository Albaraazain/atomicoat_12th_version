// lib/presentation/widgets/playback/playback_viewer.dart
import 'package:experiment_planner/domain/models/process/data_point.dart';
import 'package:flutter/material.dart';

class PlaybackViewer extends StatefulWidget {
  final String recordingId;

  const PlaybackViewer({
    Key? key,
    required this.recordingId,
  }) : super(key: key);

  @override
  State<PlaybackViewer> createState() => _PlaybackViewerState();
}

class _PlaybackViewerState extends State<PlaybackViewer> {
  late DataPlaybackService _playbackService;
  final Map<String, List<DataPoint>> _parameterData = {};
  bool _isAnalysisMode = false;

  @override
  void initState() {
    super.initState();
    _playbackService = DataPlaybackService(
      recordingId: widget.recordingId,
    );
    _initializePlayback();
  }

  Future<void> _initializePlayback() async {
    await _playbackService.initialize();
    _playbackService.dataStream.listen(_handlePlaybackData);
  }

  void _handlePlaybackData(PlaybackData data) {
    setState(() {
      for (final entry in data.values.entries) {
        _parameterData.putIfAbsent(entry.key, () => []);
        _parameterData[entry.key]!.add(DataPoint(
          timestamp: data.timestamp,
          value: entry.value,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording Playback'),
        actions: [
          IconButton(
            icon: Icon(_isAnalysisMode ? Icons.play_circle : Icons.analytics),
            onPressed: () {
              setState(() {
                _isAnalysisMode = !_isAnalysisMode;
              });
            },
            tooltip: _isAnalysisMode ? 'Playback Mode' : 'Analysis Mode',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isAnalysisMode
                ? _buildAnalysisView()
                : _buildPlaybackView(),
          ),
          _buildPlaybackControls(),
        ],
      ),
    );
  }

  Widget _buildPlaybackView() {
    return StreamBuilder<PlaybackData>(
      stream: _playbackService.dataStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
          ),
          itemCount: _parameterData.length,
          itemBuilder: (context, index) {
            final parameter = _parameterData.keys.elementAt(index);
            return _buildParameterCard(parameter);
          },
        );
      },
    );
  }

  Widget _buildAnalysisView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatisticalAnalysis(),
        const SizedBox(height: 16),
        _buildCorrelationAnalysis(),
        const SizedBox(height: 16),
        _buildTrendAnalysis(),
      ],
    );
  }

  Widget _buildParameterCard(String parameter) {
    final data = _parameterData[parameter] ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parameter,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              child: RealTimeChart(
                data: data,
                showGrid: true,
              ),
            ),
            if (data.isNotEmpty)
              Text(
                'Current: ${data.last.value.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return StreamBuilder<PlaybackState>(
      stream: _playbackService.stateStream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? PlaybackState(
          totalDuration: Duration.zero,
          currentPosition: Duration.zero,
          isPlaying: false,
          speed: 1.0,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: state.currentPosition.inMilliseconds.toDouble(),
                  max: state.totalDuration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    _playbackService.seekTo(Duration(
                      milliseconds: value.round(),
                    ));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () => _playbackService.seekTo(Duration.zero),
                    ),
                    IconButton(
                      icon: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (state.isPlaying) {
                          _playbackService.pause();
                        } else {
                          _playbackService.play();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () => _playbackService.stop(),
                    ),
                    PopupMenuButton<double>(
                      initialValue: state.speed,
                      onSelected: (speed) {
                        // Implement speed change
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 0.5,
                          child: Text('0.5x'),
                        ),
                        const PopupMenuItem(
                          value: 1.0,
                          child: Text('1.0x'),
                        ),
                        const PopupMenuItem(
                          value: 2.0,
                          child: Text('2.0x'),
                        ),
                      ],
                      child: Chip(
                        label: Text('${state.speed}x'),
                      ),
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

  @override
  void dispose() {
    _playbackService.dispose();
    super.dispose();
  }
}
