class ServiceProvider {
  final String id;
  final String name;
  final String serviceType;
  final String avatarUrl;
  final double rating;
  final double distanceKm;
  final bool available;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.avatarUrl,
    required this.rating,
    required this.distanceKm,
    required this.available,
  });
}
