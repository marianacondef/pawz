import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/vet_clinic.dart';

class OverpassService {
  static const String _baseUrl = 'https://overpass-api.de/api/interpreter';
  static const double _radiusMeters = 5000;

  static Future<List<VetClinic>> fetchNearbyVets({
    required double lat,
    required double lng,
  }) async {
    final query = '[out:json][timeout:25];'
        '(node["amenity"="veterinary"](around:$_radiusMeters,$lat,$lng);'
        'way["amenity"="veterinary"](around:$_radiusMeters,$lat,$lng););'
        'out center;';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'User-Agent': 'Pawz/1.0',
      },
      body: 'data=${Uri.encodeComponent(query)}',
    );

    if (response.statusCode != 200) {
      throw Exception('Overpass API error: ${response.statusCode}');
    }


    final data = jsonDecode(response.body);
    final elements = data['elements'] as List<dynamic>;

    final clinics = elements.map((e) {
      final tags = e['tags'] as Map<String, dynamic>? ?? {};
      final double clinicLat = e['lat'] ?? e['center']['lat'];
      final double clinicLng = e['lon'] ?? e['center']['lon'];

      final distance = _haversineKm(lat, lng, clinicLat, clinicLng);
      final name = tags['name'] ?? 'Vet';
      final street = tags['addr:street'] ?? '';
      final houseNumber = tags['addr:housenumber'] ?? '';
      final city = tags['addr:city'] ?? '';
      final phone = (tags['phone'] as String?)?.trim();
      final address = [
        if (street.isNotEmpty) '$street ${houseNumber}'.trim(),
        if (city.isNotEmpty) city,
      ].join(', ');

      return VetClinic(
        id: '${e['id']}',
        name: name,
        address: address.isNotEmpty ? address : 'No address available',
        phone: phone?.isEmpty == true ? null : phone,
        lat: clinicLat,
        lng: clinicLng,
        distanceKm: distance,
      );
    }).toList();

    clinics.sort((a, b) =>
        (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));

    return clinics;
  }

  static double _haversineKm(
      double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) *
            cos(_toRad(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return double.parse((r * c).toStringAsFixed(1));
  }

  static double _toRad(double deg) => deg * (pi / 180);
}