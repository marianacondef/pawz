import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../models/pet.dart';
import '../widgets/pawz_app_bar.dart';
import 'pet_detail_screen.dart';
import 'new_pet_screen.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF7),
      appBar: const PawzAppBar(),
      body: Consumer<PetProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Family',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF171D1B),
                  ),
                ),
                const SizedBox(height: 32),
                if (provider.pets.isEmpty)
                  Center(
                    child: Text(
                      'Add your first pet to get started!',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF5E7566),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.pets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (_, i) => _PetCard(pet: provider.pets[i]),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final option = await _showAddOptionsSheet(context);

          if (!context.mounted || option == null) {
            return;
          }

          switch (option) {
            case _AddOption.pet:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewPetScreen()),
              );
              break;
            case _AddOption.vaccine:
              _showComingSoon(context, 'Vaccine');
              break;
            case _AddOption.antiparasitic:
              _showComingSoon(context, 'Antiparasitic');
              break;
            case _AddOption.medicine:
              _showComingSoon(context, 'Medicine');
              break;
            case _AddOption.calendarEvent:
              _showComingSoon(context, 'Calendar Event');
              break;
          }
        },
        backgroundColor: const Color(0xFF4A7C59),
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<_AddOption?> _showAddOptionsSheet(BuildContext context) {
    return showModalBottomSheet<_AddOption>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => const _AddOptionsSheet(),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label option coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Pet pet;
  const _PetCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(pet);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PetDetailScreen(pet: pet)),
      ),
      onLongPress: () => _showPetActions(context),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1C2B20).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _PetAvatar(pet: pet),
                const SizedBox(width: 20),
                Text(
                  pet.name,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1C2B20),
                  ),
                ),
              ],
            ),
            _StatusBadge(status: status),
          ],
        ),
      ),
    );
  }

  _PetStatus _getStatus(Pet pet) {
    // Lógica placeholder — será expandida na Fase 2
    return _PetStatus.upToDate;
  }

  Future<void> _showPetActions(BuildContext context) async {
    final option = await showModalBottomSheet<_PetAction>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5FAF7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDEE4E1),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _ActionRow(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: const Color(0xFF171D1B),
                      onTap: () => Navigator.pop(context, _PetAction.edit),
                    ),
                    const SizedBox(height: 8),
                    _ActionRow(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      color: const Color(0xFFD64045),
                      onTap: () => Navigator.pop(context, _PetAction.delete),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    switch (option) {
      case _PetAction.edit:
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewPetScreen(pet: pet)),
        );
        break;
      case _PetAction.delete:
        final confirmed = await _confirmDelete(context);
        if (!context.mounted || confirmed != true) return;
        await context.read<PetProvider>().deletePet(pet.id);
        break;
      case null:
        break;
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete pet?',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF171D1B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This will remove ${pet.name} permanently.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF6B8F71),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryButton(
                      label: 'Cancel',
                      onTap: () => Navigator.pop(dialogContext, false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryGradientButton(
                      label: 'Delete',
                      onTap: () => Navigator.pop(dialogContext, true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  final Pet pet;
  const _PetAvatar({required this.pet});

  @override
  Widget build(BuildContext context) {
    if (pet.photoPath != null) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: FileImage(File(pet.photoPath!)),
      );
    }
    return CircleAvatar(
      radius: 28,
      backgroundColor: const Color(0xFFB7D9C2),
      child: Text(
        pet.name[0].toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF316342),
        ),
      ),
    );
  }
}

enum _PetStatus { upToDate, vaccineDue, medicineDue, antiparasiticDue }

enum _PetAction { edit, delete }

enum _AddOption { pet, vaccine, antiparasitic, medicine, calendarEvent }

class _StatusBadge extends StatelessWidget {
  final _PetStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = switch (status) {
      _PetStatus.upToDate => (
          label: 'Up to Date',
          bg: const Color(0xFF316342).withOpacity(0.1),
          text: const Color(0xFF316342),
        ),
      _PetStatus.vaccineDue => (
          label: 'Vaccine Due',
          bg: const Color(0xFFE6A817).withOpacity(0.1),
          text: const Color(0xFF7A5A0C),
        ),
      _PetStatus.medicineDue => (
          label: 'Medicine Due',
          bg: const Color(0xFF4A90E2).withOpacity(0.1),
          text: const Color(0xFF1A5FB4),
        ),
      _PetStatus.antiparasiticDue => (
          label: 'Antiparasitic Due',
          bg: const Color(0xFF9B59B6).withOpacity(0.1),
          text: const Color(0xFF7D3C98),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        config.label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: config.text,
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryGradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF316342), Color(0xFF4A7C59)],
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF316342),
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddOptionsSheet extends StatelessWidget {
  const _AddOptionsSheet();

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF5FAF7);
    const divider = Color(0xFFEAEFEC);
    const textPrimary = Color(0xFF171D1B);
    const textSecondary = Color(0xFF6B8F71);
    const iconColor = Color(0xFF4F8460);
    const handleColor = Color(0xFFDDE8E1);

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add New',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _AddOptionRow(
              title: 'Pet',
              subtitle: 'Add a new animal profile',
              icon: Icons.pets,
              iconBackground: background,
              iconColor: iconColor,
              onTap: () => Navigator.pop(context, _AddOption.pet),
            ),
            const _OptionDivider(color: divider),
            _AddOptionRow(
              title: 'Vaccine',
              subtitle: 'Log a vaccination record',
              icon: Icons.vaccines_outlined,
              iconBackground: background,
              iconColor: iconColor,
              onTap: () => Navigator.pop(context, _AddOption.vaccine),
            ),
            const _OptionDivider(color: divider),
            _AddOptionRow(
              title: 'Antiparasitic',
              subtitle: 'Log a treatment record',
              icon: Icons.shield_outlined,
              iconBackground: background,
              iconColor: iconColor,
              onTap: () => Navigator.pop(context, _AddOption.antiparasitic),
            ),
            const _OptionDivider(color: divider),
            _AddOptionRow(
              title: 'Medicine',
              subtitle: 'Log a medication dose',
              icon: Icons.medication_outlined,
              iconBackground: background,
              iconColor: iconColor,
              onTap: () => Navigator.pop(context, _AddOption.medicine),
              titleSize: 15,
              titleHeight: 1.5,
            ),
            const _OptionDivider(color: handleColor),
            _AddOptionRow(
              title: 'Calendar Event',
              subtitle: 'Schedule a visit, trip or reminder',
              icon: Icons.event_outlined,
              iconBackground: background,
              iconColor: iconColor,
              onTap: () => Navigator.pop(context, _AddOption.calendarEvent),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AddOptionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onTap;
  final double titleSize;
  final double titleHeight;

  const _AddOptionRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
    this.titleSize = 14,
    this.titleHeight = 20 / 14,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: titleSize,
                        height: titleHeight,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF171D1B),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B8F71),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: Color(0xFF7EA08B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionDivider extends StatelessWidget {
  final Color color;

  const _OptionDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
      ),
    );
  }
}
