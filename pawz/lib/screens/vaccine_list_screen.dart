import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/vaccine.dart';

class VaccineListScreen extends StatelessWidget {
  final String petId;
  const VaccineListScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Vaccine>('vaccines');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Vaccine> b, _) {
        final vaccines = b.values.where((v) => v.petId == petId).toList();

        if (vaccines.isEmpty) {
          return const Center(child: Text('Nenhuma vacina registada.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vaccines.length,
          itemBuilder: (_, i) {
            final v = vaccines[i];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.vaccines),
                title: Text(v.name),
                subtitle: v.nextDoseDate != null
                    ? Text('Próxima dose: ${v.nextDoseDate!.day}/${v.nextDoseDate!.month}/${v.nextDoseDate!.year}')
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}