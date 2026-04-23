import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:uuid/uuid.dart'; // adiciona uuid ao pubspec se quiseres IDs únicos
import '../models/pet.dart';

class PetProvider extends ChangeNotifier {
  late Box<Pet> _box;
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  PetProvider() {
    _box = Hive.box<Pet>('pets');
    _loadPets();
  }

  void _loadPets() {
    _pets = _box.values.toList();
    notifyListeners();
  }

  Future<void> addPet({
    required String name,
    required String species,
    DateTime? birthDate,
    DateTime? adoptionDate,
    double? weight,
    String? microchip,
    String? photoPath,
  }) async {
    final pet = Pet()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..name = name
      ..species = species
      ..birthDate = birthDate
      ..adoptionDate = adoptionDate
      ..weight = weight
      ..microchip = microchip
      ..photoPath = photoPath;

    await _box.put(pet.id, pet);
    _loadPets();
  }

  Future<void> deletePet(String id) async {
    await _box.delete(id);
    _loadPets();
  }

  Future<void> updatePet({
    required String id,
    required String name,
    required String species,
    DateTime? birthDate,
    DateTime? adoptionDate,
    double? weight,
    String? microchip,
    String? photoPath,
  }) async {
    final pet = _box.get(id);
    if (pet == null) {
      return;
    }

    pet
      ..name = name
      ..species = species
      ..birthDate = birthDate
      ..adoptionDate = adoptionDate
      ..weight = weight
      ..microchip = microchip
      ..photoPath = photoPath;

    await pet.save();
    _loadPets();
  }

  Pet? getPetById(String id) {
    return _pets.firstWhere((p) => p.id == id, orElse: () => throw Exception('Pet not found'));
  }
}