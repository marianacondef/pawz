import 'package:flutter/material.dart';

import 'nearby_vets_colors.dart';

class NearbyVetsRecenterButton extends StatelessWidget {
  const NearbyVetsRecenterButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.my_location, color: NearbyVetsColors.green, size: 22),
      ),
    );
  }
}
