import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/pet_provider.dart';

class NewPetScreen extends StatefulWidget {
  const NewPetScreen({super.key});

  @override
  State<NewPetScreen> createState() => _NewPetScreenState();
}

class _NewPetScreenState extends State<NewPetScreen> {
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _adoptionDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _microchipController = TextEditingController();
  final _microchipDateController = TextEditingController();

  String? _selectedSpecies;
  String? _photoPath;
  final _now = DateTime.now();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _adoptionDateController.dispose();
    _weightController.dispose();
    _microchipController.dispose();
    _microchipDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF6B8F71);
    const textColor = Color(0xFF171D1B);
    const hintColor = Color(0xFFC1C9BF);
    const borderColor = Color(0xFF6B7280);
    const dividerColor = Color(0xFFDDE8E1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textColor, size: 16),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Pet',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
            height: 1.5,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: _pickPhoto,
                    child: _DashedCircle(
                      size: 80,
                      color: const Color(0xFFC1C9BF),
                      background: const Color(0xFFF0F5F2),
                      child: _photoPath == null
                          ? const Icon(Icons.photo_camera_outlined, color: Color(0xFF6B8F71), size: 22)
                          : ClipOval(
                              child: Image.file(
                                File(_photoPath!),
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _FieldLabel(text: 'NAME *', color: labelColor),
                _UnderlineTextField(
                  controller: _nameController,
                  hintText: "Pet's name",
                  hintColor: hintColor,
                  borderColor: borderColor,
                ),
                const SizedBox(height: 24),
                _FieldLabel(text: 'SPECIES *', color: labelColor),
                DropdownButtonFormField<String>(
                  value: _selectedSpecies,
                  decoration: _inputDecoration(hintColor, borderColor, hasDropdown: true),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
                  items: const [
                    DropdownMenuItem(value: 'dog', child: Text('Dog')),
                    DropdownMenuItem(value: 'cat', child: Text('Cat')),
                    DropdownMenuItem(value: 'hamster', child: Text('Hamster')),
                    DropdownMenuItem(value: 'rabbit', child: Text('Rabbit')),
                    DropdownMenuItem(value: 'bird', child: Text('Bird')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) => setState(() => _selectedSpecies = value),
                  hint: Text(
                    'Select species',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _FieldLabel(text: 'BIRTH DATE (approximate)', color: labelColor),
                _UnderlineTextField(
                  controller: _birthDateController,
                  hintText: 'DD / MM / YYYY',
                  hintColor: hintColor,
                  borderColor: borderColor,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: borderColor),
                  readOnly: true,
                  onTap: () => _pickDate(_birthDateController),
                ),
                const SizedBox(height: 4),
                Text(
                  'Approximate is fine',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: hintColor,
                  ),
                ),
                const SizedBox(height: 20),
                _FieldLabel(text: 'ADOPTION DATE', color: labelColor),
                _UnderlineTextField(
                  controller: _adoptionDateController,
                  hintText: 'DD / MM / YYYY',
                  hintColor: hintColor,
                  borderColor: borderColor,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: borderColor),
                  readOnly: true,
                  onTap: () => _pickDate(_adoptionDateController),
                ),
                const SizedBox(height: 24),
                _FieldLabel(text: 'WEIGHT', color: labelColor),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _UnderlineTextField(
                        controller: _weightController,
                        hintText: '0.0',
                        hintColor: hintColor,
                        borderColor: borderColor,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'kg',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF717971),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _FieldLabel(text: 'MICROCHIP', color: labelColor),
                _UnderlineTextField(
                  controller: _microchipController,
                  hintText: '985 000 000 000 000 (optional)',
                  hintColor: hintColor,
                  borderColor: borderColor,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                _FieldLabel(text: 'MICROCHIP APPLICATION DATE', color: labelColor),
                _UnderlineTextField(
                  controller: _microchipDateController,
                  hintText: 'DD / MM / YYYY',
                  hintColor: hintColor,
                  borderColor: borderColor,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: borderColor),
                  readOnly: true,
                  onTap: () => _pickDate(_microchipDateController),
                ),
                const SizedBox(height: 32),
                Divider(color: dividerColor, height: 1),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.white.withOpacity(0.95),
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _savePet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A7C59),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Text(
                        'Save Pet',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(Color hintColor, Color borderColor, {bool hasDropdown = false}) {
    return InputDecoration(
      isDense: true,
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: hintColor.withOpacity(0.6),
      ),
      contentPadding: EdgeInsets.only(left: 12, right: hasDropdown ? 32 : 12, top: 10, bottom: 11),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: borderColor)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: borderColor, width: 1.2)),
    );
  }

  Future<void> _savePet() async {
    final name = _nameController.text.trim();
    final species = _selectedSpecies;

    if (name.isEmpty || species == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in required fields.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final birthDate = _parseDate(_birthDateController.text);
    final adoptionDate = _parseDate(_adoptionDateController.text);
    final weight = _parseWeight(_weightController.text);
    final microchip = _microchipController.text.trim().isEmpty
        ? null
        : _microchipController.text.trim();

    await context.read<PetProvider>().addPet(
          name: name,
          species: species,
          birthDate: birthDate,
          adoptionDate: adoptionDate,
          weight: weight,
          microchip: microchip,
          photoPath: _photoPath,
        );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final initialDate = _parseDate(controller.text) ?? _now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: _now,
    );

    if (picked != null) {
      controller.text = _formatDate(picked);
    }
  }

  Future<void> _pickPhoto() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (image != null && mounted) {
      setState(() => _photoPath = image.path);
    }
  }

  DateTime? _parseDate(String value) {
    final parts = value.split(' / ');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day / $month / ${date.year}';
  }

  double? _parseWeight(String value) {
    final sanitized = value.replaceAll(',', '.').trim();
    if (sanitized.isEmpty) return null;
    return double.tryParse(sanitized);
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _FieldLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.55,
      ),
    );
  }
}

class _UnderlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color hintColor;
  final Color borderColor;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const _UnderlineTextField({
    required this.controller,
    required this.hintText,
    required this.hintColor,
    required this.borderColor,
    this.suffixIcon,
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF171D1B),
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: hintColor.withOpacity(0.6),
        ),
        contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 11),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: borderColor)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: borderColor, width: 1.2)),
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(minHeight: 18, minWidth: 24),
      ),
    );
  }
}

class _DashedCircle extends StatelessWidget {
  final double size;
  final Color color;
  final Color background;
  final Widget child;

  const _DashedCircle({
    required this.size,
    required this.color,
    required this.background,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCirclePainter(color: color),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  const _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    final radius = size.width / 2;
    final circumference = 2 * 3.141592653589793 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final sweep = (dashWidth / circumference) * 2 * 3.141592653589793;
    final gap = (dashSpace / circumference) * 2 * 3.141592653589793;

    var startAngle = -3.141592653589793 / 2;
    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius - 1),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) => oldDelegate.color != color;
}
