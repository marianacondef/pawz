import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nearby_vets_colors.dart';

class NearbyVetsSearchBar extends StatelessWidget {
  const NearbyVetsSearchBar({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF9DD3AA), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, color: NearbyVetsColors.textMid, size: 18),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: NearbyVetsColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'Search for clinics or services...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: NearbyVetsColors.textMid,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              ),
            ),
          ),
          const Icon(Icons.tune, color: NearbyVetsColors.textMid, size: 18),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
