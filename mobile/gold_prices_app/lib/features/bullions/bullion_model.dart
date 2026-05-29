import 'package:hive/hive.dart';

part 'bullion_model.g.dart';

@HiveType(typeId: 1)
class BullionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double weight;
  @HiveField(3)
  final String karat;
  @HiveField(4)
  final double price;

  BullionModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.karat,
    required this.price,
  });

  factory BullionModel.fromJson(Map<String, dynamic> json) {
    return BullionModel(
      id: json['id'].toString(),
      name: json['name'],
      weight: json['weight'].toDouble(),
      karat: json['karat'],
      price: json['price'].toDouble(),
    );
  }
}
