// lib/presentation/widgets/analysis/_analysis_view.dart
import 'package:experiment_planner/domain/models/analysis/analysis_result.dart';
import 'package:flutter/material.dart';

class AnalysisView extends StatelessWidget {
  final AnalysisResult result;

  const AnalysisView({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildFilmCharacteristicsCard(),
        const SizedBox(height: 16),
        _buildUniformityAnalysis(),
        const SizedBox(height: 16),
        _buildCompositionAnalysis(),
        const SizedBox(height: 16),
        _buildQualityScoreCard(),
      ],
    );
  }

  Widget _buildFilmCharacteristicsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Film Characteristics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCharacteristicRow(
              'Thickness',
              '${result.filmThickness.toStringAsFixed(2)} nm',
            ),
            _buildCharacteristicRow(
              'Growth Per Cycle',
              '${result.growthPerCycle.toStringAsFixed(3)} Å/cycle',
            ),
            _buildCharacteristicRow(
              'Surface Roughness',
              '${result.surfaceRoughness.toStringAsFixed(2)} nm',
            ),
            _buildCharacteristicRow(
              'Density',
              '${result.filmDensity.toStringAsFixed(2)} g/cm³',
            ),
            _buildCharacteristicRow(
              'Refractive Index',
              result.refractiveIndex.toStringAsFixed(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUniformityAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uniformity Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            UniformityMap(
              uniformity: result.uniformity,
              conformality: result.conformality,
            ),
          ],
        ),
      ),
    );
  }
}
