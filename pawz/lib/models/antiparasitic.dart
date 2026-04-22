import 'package:hive/hive.dart';
part 'antiparasitic.g.dart';

@HiveType(typeId: 2)
class Antiparasitic extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String petId;

  @HiveField(2)
  late String product;

  @HiveField(3)
  late String type;

  @HiveField(4)
  DateTime? appliedDate;

  @HiveField(5)
  DateTime? nextApplicationDate;
}