// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bullion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BullionModelAdapter extends TypeAdapter<BullionModel> {
  @override
  final int typeId = 1;

  @override
  BullionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BullionModel(
      id: fields[0] as String,
      name: fields[1] as String,
      weight: fields[2] as double,
      karat: fields[3] as String,
      price: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BullionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.karat)
      ..writeByte(4)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BullionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
