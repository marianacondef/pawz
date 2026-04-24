import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../models/vet_clinic.dart';
import 'nearby_vets_colors.dart';

class NearbyVetsMap extends StatelessWidget {
  const NearbyVetsMap({
    super.key,
    required this.mapController,
    required this.userLocation,
    required this.filteredClinics,
    required this.onClinicDetails,
  });

  final MapController mapController;
  final LatLng? userLocation;
  final List<VetClinic> filteredClinics;
  final ValueChanged<VetClinic> onClinicDetails;

  @override
  Widget build(BuildContext context) {
    final center = userLocation ?? const LatLng(38.7169, -9.1399);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 14,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.pawz',
        ),
        MarkerLayer(
          markers: [
            if (userLocation != null)
              Marker(
                point: userLocation!,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: NearbyVetsColors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: NearbyVetsColors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ...filteredClinics.take(20).map(
              (clinic) => Marker(
                point: LatLng(clinic.lat, clinic.lng),
                width: 60,
                height: 50,
                child: GestureDetector(
                  onTap: () => onClinicDetails(clinic),
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: NearbyVetsColors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_hospital,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      if (clinic.distanceKm != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            '${clinic.distanceKm}km',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: NearbyVetsColors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
