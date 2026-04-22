import 'package:hive/hive.dart';
part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String species;

  @HiveField(3)
  DateTime? birthDate;

  @HiveField(4)
  DateTime? adoptionDate;

  @HiveField(5)
  double? weight;

  @HiveField(6)
  String? microchip;

  @HiveField(7)
  String? photoPath;
}