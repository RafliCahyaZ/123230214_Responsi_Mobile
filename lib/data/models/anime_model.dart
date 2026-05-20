class Anime {
  const Anime({
    required this.id,
    required this.titleEnJp,
    required this.canonicalTitle,
    required this.posterImage,
    required this.coverImage,
    required this.ageRating,
    required this.ageRatingGuide,
    required this.episodeCount,
    required this.averageRating,
    required this.synopsis,
    required this.status,
    required this.startDate,
  });

  final String id;
  final String titleEnJp;
  final String canonicalTitle;
  final String posterImage;
  final String coverImage;
  final String ageRating;
  final String ageRatingGuide;
  final int episodeCount;
  final String averageRating;
  final String synopsis;
  final String status;
  final String startDate;

  factory Anime.fromJson(Map<String, dynamic> json) {
    final attributes = (json['attributes'] as Map<String, dynamic>?) ?? {};
    final titles = (attributes['titles'] as Map<String, dynamic>?) ?? {};
    final poster = (attributes['posterImage'] as Map<String, dynamic>?) ?? {};
    final cover = (attributes['coverImage'] as Map<String, dynamic>?) ?? {};

    return Anime(
      id: (json['id'] ?? '').toString(),
      titleEnJp: _stringOrFallback(titles['en_jp'], attributes['canonicalTitle'], 'Tanpa Judul'),
      canonicalTitle: _stringOrFallback(attributes['canonicalTitle'], titles['en_jp'], 'Tanpa Judul'),
      posterImage: _stringOrFallback(poster['large'], poster['medium'], ''),
      coverImage: _stringOrFallback(cover['large'], cover['original'], _stringOrFallback(poster['large'], poster['medium'], '')),
      ageRating: _stringOrFallback(attributes['ageRating'], null, 'N/A'),
      ageRatingGuide: _stringOrFallback(attributes['ageRatingGuide'], null, 'Tidak tersedia'),
      episodeCount: _intOrZero(attributes['episodeCount']),
      averageRating: _stringOrFallback(attributes['averageRating'], null, 'N/A'),
      synopsis: _stringOrFallback(attributes['synopsis'], null, 'Sinopsis belum tersedia.'),
      status: _stringOrFallback(attributes['status'], null, 'Unknown'),
      startDate: _stringOrFallback(attributes['startDate'], null, '-'),
    );
  }

  factory Anime.fromMap(Map<dynamic, dynamic> map) {
    return Anime(
      id: (map['id'] ?? '').toString(),
      titleEnJp: (map['titleEnJp'] ?? 'Tanpa Judul').toString(),
      canonicalTitle: (map['canonicalTitle'] ?? map['titleEnJp'] ?? 'Tanpa Judul').toString(),
      posterImage: (map['posterImage'] ?? '').toString(),
      coverImage: (map['coverImage'] ?? map['posterImage'] ?? '').toString(),
      ageRating: (map['ageRating'] ?? 'N/A').toString(),
      ageRatingGuide: (map['ageRatingGuide'] ?? 'Tidak tersedia').toString(),
      episodeCount: _intOrZero(map['episodeCount']),
      averageRating: (map['averageRating'] ?? 'N/A').toString(),
      synopsis: (map['synopsis'] ?? 'Sinopsis belum tersedia.').toString(),
      status: (map['status'] ?? 'Unknown').toString(),
      startDate: (map['startDate'] ?? '-').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleEnJp': titleEnJp,
      'canonicalTitle': canonicalTitle,
      'posterImage': posterImage,
      'coverImage': coverImage,
      'ageRating': ageRating,
      'ageRatingGuide': ageRatingGuide,
      'episodeCount': episodeCount,
      'averageRating': averageRating,
      'synopsis': synopsis,
      'status': status,
      'startDate': startDate,
    };
  }

  String get episodeText => episodeCount > 0 ? '$episodeCount Episode' : 'Episode N/A';
  String get ratingText => averageRating == 'N/A' ? 'Rating N/A' : '$averageRating/100';

  static String _stringOrFallback(dynamic value, dynamic second, String fallback) {
    final primary = value?.toString().trim();
    if (primary != null && primary.isNotEmpty && primary != 'null') return primary;
    final secondary = second?.toString().trim();
    if (secondary != null && secondary.isNotEmpty && secondary != 'null') return secondary;
    return fallback;
  }

  static int _intOrZero(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
