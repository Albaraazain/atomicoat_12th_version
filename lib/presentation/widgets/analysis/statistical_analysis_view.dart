// lib/presentation/widgets/analysis/statistical_analysis_view.dart
import 'package:experiment_planner/domain/enums/analysis_enums.dart';
import 'package:experiment_planner/domain/models/process/data_point.dart';
import 'package:experiment_planner/domain/services/analysis/statistical_analyzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatisticalAnalysisView extends StatelessWidget {
  final List<DataPoint> data;
  final String parameterName;
  final String? unit;

  const StatisticalAnalysisView({
    Key? key,
    required this.data,
    required this.parameterName,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No data available for analysis'),
      );
    }

    final summary = StatisticalAnalyzer.analyze(data);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(summary),
        const SizedBox(height: 16),
        _buildDistributionChart(summary),
        const SizedBox(height: 16),
        _buildOutliersCard(summary),
        const SizedBox(height: 16),
        _buildTrendsCard(summary),
      ],
    );
  }

  Widget _buildSummaryCard(StatisticalSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistical Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryGrid(summary),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(StatisticalSummary summary) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      children: [
        _buildMetricTile('Mean', summary.mean),
        _buildMetricTile('Median', summary.median),
        _buildMetricTile('Std Dev', summary.standardDeviation),
        _buildMetricTile('Range', summary.max - summary.min),
        _buildMetricTile('Min', summary.min),
        _buildMetricTile('Max', summary.max),
        _buildMetricTile('Q1', summary.quartiles.q1),
        _buildMetricTile('Q3', summary.quartiles.q3),
      ],
    );
  }

  Widget _buildMetricTile(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)}${unit ?? ''}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionChart(StatisticalSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: DistributionChart(
                data: data,
                summary: summary,
                unit: unit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutliersCard(StatisticalSummary summary) {
    if (summary.outliers.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('No outliers detected'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Outliers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: summary.outliers.length,
              itemBuilder: (context, index) {
                final outlier = summary.outliers[index];
                return ListTile(
                  leading: Icon(
                    outlier.severity == OutlierSeverity.severe
                        ? Icons.warning
                        : Icons.info_outline,
                    color: outlier.severity == OutlierSeverity.severe
                        ? Colors.red
                        : Colors.orange,
                  ),
                  title: Text(
                    '${outlier.value.toStringAsFixed(2)}${unit ?? ''}',
                  ),
                  subtitle: Text(
                    outlier.severity == OutlierSeverity.severe
                        ? 'Extreme outlier'
                        : 'Mild outlier',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
