// lib/domain/models/session/substrate_info.dart
class SubstrateInfo {
  final String material;
  final String size;
  final String preparation;
  final Map<String, String> properties;
  final String? pretreatment;
  final DateTime preparationDate;

  SubstrateInfo({
    required this.material,
    required this.size,
    required this.preparation,
    required this.properties,
    this.pretreatment,
    required this.preparationDate,
  });

  @override
  String toString() {
    return '$material ($size) - $preparation';
  }
}