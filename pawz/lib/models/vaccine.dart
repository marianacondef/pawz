import 'package:hive/hive.dart';
part 'vaccine.g.dart';

@HiveType(typeId: 1)
class Vaccine extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String petId;

  @HiveField(2)
  late String name;

  @HiveField(3)
  String? manufacturer;

  @HiveField(4)
  String? batchNumber;

  @HiveField(5)
  String? clinic;

  @HiveField(6)
  DateTime? administeredDate;

  @HiveField(7)
  DateTime? nextDoseDate;
}