// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VaccineAdapter extends TypeAdapter<Vaccine> {
  @override
  final int typeId = 1;

  @override
  Vaccine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vaccine()
      ..id = fields[0] as String
      ..petId = fields[1] as String
      ..name = fields[2] as String
      ..manufacturer = fields[3] as String?
      ..batchNumber = fields[4] as String?
      ..clinic = fields[5] as String?
      ..administeredDate = fields[6] as DateTime?
      ..nextDoseDate = fields[7] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Vaccine obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.petId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.manufacturer)
      ..writeByte(4)
      ..write(obj.batchNumber)
      ..writeByte(5)
      ..write(obj.clinic)
      ..writeByte(6)
      ..write(obj.administeredDate)
      ..writeByte(7)
      ..write(obj.nextDoseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaccineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
