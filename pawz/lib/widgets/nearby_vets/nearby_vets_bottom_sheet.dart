import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/vet_clinic.dart';
import 'nearby_vets_colors.dart';
import 'vet_clinic_card.dart';

class NearbyVetsBottomSheet extends StatelessWidget {
  const NearbyVetsBottomSheet({
    super.key,
    required this.scrollController,
    required this.loading,
    required this.error,
    required this.filteredClinics,
    required this.onRetry,
    required this.onDirections,
    required this.onViewDetails,
  });

  final ScrollController scrollController;
  final bool loading;
  final String? error;
  final List<VetClinic> filteredClinics;
  final VoidCallback onRetry;
  final ValueChanged<VetClinic> onDirections;
  final ValueChanged<VetClinic> onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF0F5F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFC1C9BF).withOpacity(0.4),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Clinics in this area',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: NearbyVetsColors.textDark,
                  ),
                ),
                Text(
                  loading ? 'Loading...' : '${filteredClinics.length} results',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF386849),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildClinicList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicList(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: NearbyVetsColors.green),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off, color: NearbyVetsColors.textMid, size: 40),
              const SizedBox(height: 12),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: NearbyVetsColors.textMid,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: NearbyVetsColors.green,
                ),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredClinics.isEmpty) {
      return Center(
        child: Text(
          'No veterinarians found.',
          style: GoogleFonts.inter(
            color: NearbyVetsColors.textMid,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      itemCount: filteredClinics.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => VetClinicCard(
        clinic: filteredClinics[i],
        onDirections: () => onDirections(filteredClinics[i]),
        onViewDetails: () => onViewDetails(filteredClinics[i]),
      ),
    );
  }
}
