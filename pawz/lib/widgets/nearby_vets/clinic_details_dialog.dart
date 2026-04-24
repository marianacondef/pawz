import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/vet_clinic.dart';
import 'clinic_detail_row.dart';
import 'nearby_vets_colors.dart';

class ClinicDetailsDialog extends StatelessWidget {
  const ClinicDetailsDialog({
    super.key,
    required this.clinic,
    required this.onCall,
    required this.phoneNumbers,
  });

  final VetClinic clinic;
  final ValueChanged<String> onCall;
  final List<String> phoneNumbers;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: NearbyVetsColors.bg,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1C2B20).withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clinic.name,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: NearbyVetsColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ClinicDetailRow(
                icon: Icons.location_on_outlined,
                text: clinic.address,
              ),
              if (clinic.distanceKm != null) ...[
                const SizedBox(height: 8),
                ClinicDetailRow(
                  icon: Icons.route_outlined,
                  text: '${clinic.distanceKm} km away',
                ),
              ],
              if (phoneNumbers.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...phoneNumbers.map(
                  (phone) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      onTap: () => onCall(phone),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ClinicDetailRow(
                          icon: Icons.phone_outlined,
                          text: phone,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
