// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antiparasitic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AntiparasiticAdapter extends TypeAdapter<Antiparasitic> {
  @override
  final int typeId = 2;

  @override
  Antiparasitic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Antiparasitic()
      ..id = fields[0] as String
      ..petId = fields[1] as String
      ..product = fields[2] as String
      ..type = fields[3] as String
      ..appliedDate = fields[4] as DateTime?
      ..nextApplicationDate = fields[5] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Antiparasitic obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.petId)
      ..writeByte(2)
      ..write(obj.product)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.appliedDate)
      ..writeByte(5)
      ..write(obj.nextApplicationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntiparasiticAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
