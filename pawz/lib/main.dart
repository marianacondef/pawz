import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/pet.dart';
import 'models/vaccine.dart';
import 'models/antiparasitic.dart';
import 'models/medication.dart';
import 'providers/pet_provider.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(PetAdapter());
  Hive.registerAdapter(VaccineAdapter());
  Hive.registerAdapter(AntiparasiticAdapter());
  Hive.registerAdapter(MedicationAdapter());

  await Hive.openBox<Pet>('pets');
  await Hive.openBox<Vaccine>('vaccines');
  await Hive.openBox<Antiparasitic>('antiparasitics');
  await Hive.openBox<Medication>('medications');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
      ],
      child: const PawzApp(),
    ),
  );
}

class PawzApp extends StatelessWidget {
  const PawzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4EFF)),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const MainScreen(),
    );
  }
}