import 'package:hive/hive.dart';

part 'price_model.g.dart'; // سيتطلب تشغيل build_runner

@HiveType(typeId: 0)
class PriceModel {
  @HiveField(0)
  final String karat;
  
  @HiveField(1)
  final double price;

  PriceModel({required this.karat, required this.price});

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      karat: json['karat'].toString(),
      price: double.parse(json['price'].toString()),
    );
  }
}
