class VetClinic {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double lat;
  final double lng;
  final double? distanceKm;

  VetClinic({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.lat,
    required this.lng,
    this.distanceKm,
  });

  VetClinic copyWith({double? distanceKm}) => VetClinic(
        id: id,
        name: name,
        address: address,
        phone: phone,
        lat: lat,
        lng: lng,
        distanceKm: distanceKm ?? this.distanceKm,
      );
}