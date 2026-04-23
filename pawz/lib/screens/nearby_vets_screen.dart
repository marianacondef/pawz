import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/vet_clinic.dart';
import '../services/overpass_service.dart';

class NearbyVetsScreen extends StatefulWidget {
  const NearbyVetsScreen({super.key});

  @override
  State<NearbyVetsScreen> createState() => _NearbyVetsScreenState();
}

class _NearbyVetsScreenState extends State<NearbyVetsScreen> {
  static const _green = Color(0xFF316342);
  static const _bg = Color(0xFFF5FAF7);
  static const _textDark = Color(0xFF171D1B);
  static const _textMid = Color(0xFF717971);
  static const _cardBg = Colors.white;

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
              .where((c) =>
                  c.name.toLowerCase().contains(q) ||
                  c.address.toLowerCase().contains(q))
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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
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
    if (await launchUrl(nativeNavigationUri, mode: LaunchMode.externalApplication)) {
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
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5FAF7),
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
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  text: clinic.address,
                ),
                if (clinic.distanceKm != null) ...[
                  const SizedBox(height: 8),
                  _DetailRow(
                    icon: Icons.route_outlined,
                    text: '${clinic.distanceKm} km away',
                  ),
                ],
                if (clinic.phone != null) ...[
                  const SizedBox(height: 8),
                  ..._splitPhoneNumbers(clinic.phone!).map(
                    (phone) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        onTap: () => _callClinic(phone),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _DetailRow(
                            icon: Icons.phone_outlined,
                            text: phone,
                            trailing: Text(
                              'Call',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF316342),
                              ),
                            ),
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
      ),
    );
  }

  Future<void> _callClinic(String phone) async {
    final normalizedPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final telUri = Uri(scheme: 'tel', path: normalizedPhone);
    final launched = await launchUrl(telUri, mode: LaunchMode.externalApplication);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Mapa ocupa tela toda
          _buildMap(),

          // Header
          SafeArea(
            child: _buildHeader(),
          ),

          // Search bar sobre o mapa
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 0),
              child: _buildSearchBar(),
            ),
          ),

          // Botão recentrar
          if (_userLocation != null)
            Positioned(
              right: 16,
              bottom: (MediaQuery.of(context).size.height * _sheetExtent) + 12,
              child: _buildRecenterButton(),
            ),

          // Bottom sheet com lista
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
              builder: (context, scrollController) => _buildBottomSheet(scrollController),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _bg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.pets, color: _green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Pawz',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _green,
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: _textDark, size: 22),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: _textDark, size: 22),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF9DD3AA), width: 2),
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
          const Icon(Icons.search, color: Color(0xFF717971), size: 18),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              style: GoogleFonts.inter(fontSize: 14, color: _textDark),
              decoration: InputDecoration(
                hintText: 'Search for clinics or services...',
                hintStyle: GoogleFonts.inter(
                    fontSize: 14, color: const Color(0xFF717971)),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              ),
            ),
          ),
          const Icon(Icons.tune, color: Color(0xFF717971), size: 18),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final center = _userLocation ?? const LatLng(38.7169, -9.1399); // Lisboa

    return FlutterMap(
      mapController: _mapController,
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
            // Marcador do utilizador
            if (_userLocation != null)
              Marker(
                point: _userLocation!,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: _green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            // Marcadores dos veterinários
            ..._filteredClinics.take(20).map((clinic) => Marker(
                  point: LatLng(clinic.lat, clinic.lng),
                  width: 60,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => _focusClinic(clinic),
                    child: Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _green,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.local_hospital,
                              color: Colors.white, size: 14),
                        ),
                        if (clinic.distanceKm != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
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
                                color: _green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildRecenterButton() {
    return GestureDetector(
      onTap: _recenter,
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
        child: const Icon(Icons.my_location, color: _green, size: 22),
      ),
    );
  }

  Widget _buildBottomSheet(ScrollController scrollController) {
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
          // Drag handle
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

          // Header da lista
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
                    color: _textDark,
                  ),
                ),
                Text(
                  _loading
                      ? 'Loading...'
                      : '${_filteredClinics.length} results',
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

          // Lista
          Expanded(
            child: _buildClinicList(scrollController),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicList(ScrollController scrollController) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: _green),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off, color: _textMid, size: 40),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: _textMid, fontSize: 14),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _initLocation();
                },
                style: FilledButton.styleFrom(backgroundColor: _green),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredClinics.isEmpty) {
      return Center(
        child: Text(
          'Nenhum veterinário encontrado.',
          style: GoogleFonts.inter(color: _textMid, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      itemCount: _filteredClinics.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _ClinicCard(
        clinic: _filteredClinics[i],
        onDirections: () => _openDirections(_filteredClinics[i]),
        onViewDetails: () => _showClinicDetails(_filteredClinics[i]),
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final VetClinic clinic;
  final VoidCallback onDirections;
  final VoidCallback onViewDetails;

  const _ClinicCard({
    required this.clinic,
    required this.onDirections,
    required this.onViewDetails,
  });

  static const _green = Color(0xFF316342);
  static const _textDark = Color(0xFF171D1B);
  static const _textMid = Color(0xFF717971);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nome + distância
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      clinic.address,
                      style: GoogleFonts.inter(
                          fontSize: 13, color: _textMid),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (clinic.phone != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 13, color: _textMid),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              clinic.phone!,
                              style: GoogleFonts.inter(fontSize: 12, color: _textMid),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (clinic.distanceKm != null)
                    Text(
                      '${clinic.distanceKm} km',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _green,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Botões
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onViewDetails,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEFEC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'See details',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _green,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: onDirections,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.navigation,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'Directions',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? trailing;

  const _DetailRow({
    required this.icon,
    required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    const textMid = Color(0xFF6B8F71);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 16, color: textMid),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textMid,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}
