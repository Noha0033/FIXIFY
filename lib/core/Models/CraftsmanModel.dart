class CraftsmanModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double? distance;

  CraftsmanModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  factory CraftsmanModel.fromJson(Map<String, dynamic> json) {
    return CraftsmanModel(
      id: json['id'],
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
    );
  }
}
