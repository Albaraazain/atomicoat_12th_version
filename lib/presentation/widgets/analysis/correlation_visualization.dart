// lib/presentation/widgets/analysis/correlation_visualization.dart
import 'package:experiment_planner/domain/models/analysis/correlation_result.dart';
import 'package:flutter/material.dart';

class CorrelationVisualization extends StatefulWidget {
  final List<CorrelationResult> correlations;

  const CorrelationVisualization({
    Key? key,
    required this.correlations,
  }) : super(key: key);

  @override
  State<CorrelationVisualization> createState() => _CorrelationVisualizationState();
}

class _CorrelationVisualizationState extends State<CorrelationVisualization> {
  CorrelationResult? selectedCorrelation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCorrelationMatrix(),
        if (selectedCorrelation != null) ...[
          const SizedBox(height: 16),
          _buildDetailedAnalysis(selectedCorrelation!),
        ],
      ],
    );
  }

  Widget _buildCorrelationMatrix() {
    final uniqueParams = _getUniqueParameters();
    final size = uniqueParams.length;

    return SizedBox(
      height: 300,
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 2.0,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
          ),
          itemCount: size * size,
          itemBuilder: (context, index) {
            final row = index ~/ size;
            final col = index % size;

            if (row == col) {
              return _buildParameterCell(uniqueParams[row]);
            }

            final correlation = _findCorrelation(
              uniqueParams[row],
              uniqueParams[col],
            );

            return _buildCorrelationCell(correlation);
          },
        ),
      ),
    );
  }

  Widget _buildParameterCell(String parameter) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: Center(
        child: Text(
          parameter,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCorrelationCell(CorrelationResult? correlation) {
    if (correlation == null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
        ),
      );
    }

    final color = _getCorrelationColor(correlation.strength);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCorrelation = correlation;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            correlation.strength.toStringAsFixed(2),
            style: TextStyle(
              color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedAnalysis(CorrelationResult correlation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${correlation.parameter1} vs ${correlation.parameter2}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildCorrelationDetails(correlation),
            const SizedBox(height: 16),
            _buildLaggedCorrelationsChart(correlation),
            const SizedBox(height: 16),
            _buildCausalityAnalysis(correlation),
          ],
        ),
      ),
    );
  }

  // ... Additional helper methods and chart implementations ...
}