import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/vet_clinic.dart';
import '../services/overpass_service.dart';
import '../widgets/nearby_vets/clinic_details_dialog.dart';
import '../widgets/nearby_vets/nearby_vets_bottom_sheet.dart';
import '../widgets/nearby_vets/nearby_vets_colors.dart';
import '../widgets/nearby_vets/nearby_vets_map.dart';
import '../widgets/nearby_vets/nearby_vets_recenter_button.dart';
import '../widgets/nearby_vets/nearby_vets_search_bar.dart';

class NearbyVetsScreen extends StatefulWidget {
  const NearbyVetsScreen({super.key});

  @override
  State<NearbyVetsScreen> createState() => _NearbyVetsScreenState();
}

class _NearbyVetsScreenState extends State<NearbyVetsScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();

  LatLng? _userLocation;
  List<VetClinic> _allClinics = [];
  List<VetClinic> _filteredClinics = [];
  bool _loading = true;
  String? _error;
  double _sheetExtent = 0.56;

  @override
  void initState() {
    super.initState();
    _initLocation();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredClinics = q.isEmpty
          ? _allClinics
          : _allClinics
              .where(
                (c) =>
                    c.name.toLowerCase().contains(q) ||
                    c.address.toLowerCase().contains(q),
              )
              .toList();
    });
  }

  Future<void> _initLocation() async {
    try {
      final permission = await _requestPermission();
      if (!permission) {
        setState(() {
          _error = 'Permissão de localização negada.';
          _loading = false;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final userLatLng = LatLng(pos.latitude, pos.longitude);
      setState(() => _userLocation = userLatLng);

      _mapController.move(userLatLng, 14);

      final clinics = await OverpassService.fetchNearbyVets(
        lat: pos.latitude,
        lng: pos.longitude,
      );

      setState(() {
        _allClinics = clinics;
        _filteredClinics = clinics;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar veterinários: $e';
        _loading = false;
      });
    }
  }

  Future<bool> _requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  void _recenter() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 14);
    }
  }

  void _openDirections(VetClinic clinic) async {
    final destination = '${clinic.lat},${clinic.lng}';

    final nativeNavigationUri = Uri.parse('google.navigation:q=$destination');
    if (await launchUrl(
      nativeNavigationUri,
      mode: LaunchMode.externalApplication,
    )) {
      return;
    }

    final geoUri = Uri.parse('geo:${clinic.lat},${clinic.lng}?q=$destination');
    if (await launchUrl(geoUri, mode: LaunchMode.externalApplication)) {
      return;
    }

    final webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=driving',
    );
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  void _focusClinic(VetClinic clinic) {
    _mapController.move(LatLng(clinic.lat, clinic.lng), 16);
  }

  void _showClinicDetails(VetClinic clinic) {
    _focusClinic(clinic);
    showDialog<void>(
      context: context,
      builder: (_) => ClinicDetailsDialog(
        clinic: clinic,
        phoneNumbers:
            clinic.phone == null ? const [] : _splitPhoneNumbers(clinic.phone!),
        onCall: _callClinic,
      ),
    );
  }

  Future<void> _callClinic(String phone) async {
    final normalizedPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final telUri = Uri(scheme: 'tel', path: normalizedPhone);
    final launched = await launchUrl(
      telUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open phone dialer.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  List<String> _splitPhoneNumbers(String rawPhones) {
    return rawPhones
        .split(RegExp(r'\s*[;,]\s*'))
        .map((phone) => phone.trim())
        .where((phone) => phone.isNotEmpty)
        .toList();
  }

  void _retryLoadClinics() {
    setState(() {
      _loading = true;
      _error = null;
    });
    _initLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NearbyVetsColors.bg,
      body: Stack(
        children: [
          SafeArea(
            child: NearbyVetsMap(
              mapController: _mapController,
              userLocation: _userLocation,
              filteredClinics: _filteredClinics,
              onClinicDetails: _showClinicDetails,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: NearbyVetsSearchBar(controller: _searchCtrl),
            ),
          ),
          if (_userLocation != null)
            Positioned(
              right: 16,
              bottom: (MediaQuery.of(context).size.height * _sheetExtent) + 12,
              child: NearbyVetsRecenterButton(onTap: _recenter),
            ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() => _sheetExtent = notification.extent);
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.46,
              minChildSize: 0.18,
              maxChildSize: 0.9,
              snap: true,
              snapSizes: const [0.18, 0.46, 0.9],
              builder: (context, scrollController) => NearbyVetsBottomSheet(
                scrollController: scrollController,
                loading: _loading,
                error: _error,
                filteredClinics: _filteredClinics,
                onRetry: _retryLoadClinics,
                onDirections: _openDirections,
                onViewDetails: _showClinicDetails,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
