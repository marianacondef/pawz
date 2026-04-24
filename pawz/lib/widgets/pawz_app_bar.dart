import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nearby_vets/nearby_vets_colors.dart';

class PawzAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PawzAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: NearbyVetsColors.bg,
      elevation: 0,
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      title: Row(
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
      actions: [
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
    );
  }
}
