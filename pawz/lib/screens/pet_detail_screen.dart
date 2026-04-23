import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'vaccine_list_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;
  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(pet.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Health'),
              Tab(text: 'Mood'),
              Tab(text: 'Visits'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VaccineListScreen(petId: pet.id),
            const Center(child: Text('Mood — soon')),
            const Center(child: Text('Visits — soon')),
          ],
        ),
      ),
    );
  }
}