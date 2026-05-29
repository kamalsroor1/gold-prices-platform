// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceModelAdapter extends TypeAdapter<PriceModel> {
  @override
  final int typeId = 0;

  @override
  PriceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceModel(
      karat: fields[0] as String,
      price: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PriceModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.karat)
      ..writeByte(1)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
