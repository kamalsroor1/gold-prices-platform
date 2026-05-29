class AlertModel {
  final int id;
  final int karat;
  final double targetPrice;
  final bool isActive;

  AlertModel({
    required this.id,
    required this.karat,
    required this.targetPrice,
    required this.isActive,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      karat: json['karat'],
      targetPrice: double.parse(json['target_price'].toString()),
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}
