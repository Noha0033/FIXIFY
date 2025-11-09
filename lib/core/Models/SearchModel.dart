class SearchResult {
  final String id;
  final String name;
  final double? rating;
  final int? reviewsCount;
  final String? location;
  final String? price;
  final String? imageUrl;
  final String type;

  SearchResult({
    required this.id,
    required this.name,
    this.rating,
    this.reviewsCount,
    this.location,
    this.price,
    this.imageUrl,
    required this.type,
  });
}