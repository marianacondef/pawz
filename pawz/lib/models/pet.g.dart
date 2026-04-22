// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetAdapter extends TypeAdapter<Pet> {
  @override
  final int typeId = 0;

  @override
  Pet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pet()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..species = fields[2] as String
      ..birthDate = fields[3] as DateTime?
      ..adoptionDate = fields[4] as DateTime?
      ..weight = fields[5] as double?
      ..microchip = fields[6] as String?
      ..photoPath = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, Pet obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.species)
      ..writeByte(3)
      ..write(obj.birthDate)
      ..writeByte(4)
      ..write(obj.adoptionDate)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.microchip)
      ..writeByte(7)
      ..write(obj.photoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
