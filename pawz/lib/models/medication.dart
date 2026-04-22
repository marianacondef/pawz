import 'package:hive/hive.dart';
part 'medication.g.dart';

@HiveType(typeId: 3)
class Medication extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String petId;

  @HiveField(2)
  late String name;

  @HiveField(3)
  String? dosage;

  @HiveField(4)
  String? frequency;

  @HiveField(5)
  bool isActive = true;
}