import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nearby_vets_colors.dart';

class NearbyVetsHeader extends StatelessWidget {
  const NearbyVetsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NearbyVetsColors.bg,
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pets, color: NearbyVetsColors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Pawz',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NearbyVetsColors.green,
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: NearbyVetsColors.textDark,
                  size: 22,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: NearbyVetsColors.textDark,
                  size: 22,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }
}
