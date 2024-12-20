// lib/presentation/widgets/monitoring/real_time/real_time_dashboard.dart
class RealTimeDashboard extends StatefulWidget {
  final String machineId;

  const RealTimeDashboard({
    Key? key,
    required this.machineId,
  }) : super(key: key);

  @override
  State<RealTimeDashboard> createState() => _RealTimeDashboardState();
}

class _RealTimeDashboardState extends State<RealTimeDashboard> {
  final _updateInterval = const Duration(milliseconds: 100);
  final _bufferSize = 100; // Number of data points to show

  late Timer _updateTimer;
  Map<String, List<DataPoint>> _dataBuffer = {};

  @override
  void initState() {
    super.initState();
    _startRealTimeUpdates();
  }

  void _startRealTimeUpdates() {
    _updateTimer = Timer.periodic(_updateInterval, (_) {
      setState(() {
        // Update will be handled by StreamBuilder
      });
    });
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitoringBloc, MonitoringState>(
      builder: (context, state) {
        if (state is MonitoringInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MonitoringError) {
          return _buildErrorView(state.message);
        }

        if (state is MonitoringActive) {
          return _buildDashboard(state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDashboard(MonitoringActive state) {
    return Column(
      children: [
        _buildSystemStatus(state.systemHealth),
        const SizedBox(height: 16),
        _buildActiveAlerts(state.activeAlerts),
        const SizedBox(height: 16),
        Expanded(
          child: _buildParameterGrids(state.parameters),
        ),
      ],
    );
  }

  Widget _buildSystemStatus(SystemHealth health) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(health.status),
                  color: _getStatusColor(health.status),
                ),
                const SizedBox(width: 8),
                Text(
                  'System Status: ${health.status.toString().split('.').last}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricIndicator(
                  'CPU',
                  health.metrics.cpuUsage,
                  icon: Icons.memory,
                ),
                _buildMetricIndicator(
                  'Memory',
                  health.metrics.memoryUsage,
                  icon: Icons.storage,
                ),
                _buildMetricIndicator(
                  'Network',
                  health.metrics.networkLatency,
                  icon: Icons.network_check,
                  unit: 'ms',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveAlerts(List<MonitoringAlert> alerts) {
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Card(
            color: _getAlertColor(alert.severity).withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    _getAlertIcon(alert.type),
                    color: _getAlertColor(alert.severity),
                  ),
                  const SizedBox(width: 8),
                  Text(alert.message),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParameterGrids(List<Parameter> parameters) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: parameters.length,
      itemBuilder: (context, index) {
        return _buildParameterCard(parameters[index]);
      },
    );
  }

  Widget _buildParameterCard(Parameter parameter) {
    return Card(
      child: StreamBuilder<double>(
        stream: context
            .read<MonitoringBloc>()
            .getParameterStream(parameter.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Update buffer
          if (!_dataBuffer.containsKey(parameter.id)) {
            _dataBuffer[parameter.id] = [];
          }

          _dataBuffer[parameter.id]!.add(DataPoint(
            timestamp: DateTime.now(),
            value: snapshot.data!,
          ));

          if (_dataBuffer[parameter.id]!.length > _bufferSize) {
            _dataBuffer[parameter.id]!.removeAt(0);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      parameter.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${snapshot.data!.toStringAsFixed(2)} ${parameter.unit}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RealTimeChart(
                  data: _dataBuffer[parameter.id]!,
                  parameter: parameter,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricIndicator(
    String label,
    double value, {
    IconData? icon,
    String unit = '%',
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 4),
            ],
            Text(label),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$value$unit',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

