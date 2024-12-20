import 'package:flutter/material.dart';
import '../../../domain/entities/optimization/optimization_suggestion.dart';
import '../../../domain/enums/optimization_enums.dart';

class OptimizationSuggestionsView extends StatelessWidget {
  final List<OptimizationSuggestion> suggestions;

  const OptimizationSuggestionsView({
    Key? key,
    required this.suggestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: SuggestionType.values.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: SuggestionType.values.map((type) {
              return Tab(
                text: type.toString().split('.').last,
                icon: _getSuggestionTypeIcon(type),
              );
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: SuggestionType.values.map((type) {
                final typeSuggestions = suggestions
                    .where((s) => s.type == type)
                    .toList()
                  ..sort((a, b) => b.impact.compareTo(a.impact));

                return ListView.builder(
                  itemCount: typeSuggestions.length,
                  itemBuilder: (context, index) {
                    return _buildSuggestionCard(
                      context,
                      typeSuggestions[index],
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(
    BuildContext context,
    OptimizationSuggestion suggestion,
  ) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        leading: _getSuggestionTypeIcon(suggestion.type),
        title: Text(suggestion.description),
        subtitle: _buildImpactIndicator(suggestion.impact),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommendation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(suggestion.recommendation),
                const SizedBox(height: 16),
                _buildConfidenceIndicator(suggestion.confidence),
                if (suggestion.additionalData != null) ...[
                  const SizedBox(height: 16),
                  _buildAdditionalData(suggestion.additionalData!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactIndicator(double impact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          impact > 0.7
              ? Icons.arrow_upward
              : impact > 0.3
                  ? Icons.arrow_forward
                  : Icons.arrow_downward,
          color: _getImpactColor(impact),
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          'Impact: ${(impact * 100).toStringAsFixed(0)}%',
          style: TextStyle(color: _getImpactColor(impact)),
        ),
      ],
    );
  }

  Widget _buildConfidenceIndicator(double confidence) {
    return Row(
      children: [
        const Text('Confidence: '),
        Expanded(
          child: LinearProgressIndicator(
            value: confidence,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getConfidenceColor(confidence),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(confidence * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: _getConfidenceColor(confidence),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalData(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...data.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text(
                  '${entry.key}:',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Icon _getSuggestionTypeIcon(SuggestionType type) {
    switch (type) {
      case SuggestionType.parameterCorrelation:
        return const Icon(Icons.compare_arrows);
      case SuggestionType.energyEfficiency:
        return const Icon(Icons.power);
      case SuggestionType.cycleTime:
        return const Icon(Icons.timer);
      case SuggestionType.recipeOptimization:
        return const Icon(Icons.science);
    }
  }

  Color _getImpactColor(double impact) {
    if (impact > 0.7) return Colors.green;
    if (impact > 0.3) return Colors.orange;
    return Colors.red;
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.7) return Colors.green;
    if (confidence > 0.3) return Colors.orange;
    return Colors.red;
  }
}
