class BookResponse {
  final int id;
  final String title;
  final String authorName;
  final String isbn;
  final String synopsis;
  final String owner;
  final String cover; // byte[] sera une chaîne encodée en base64
  final double rate;
  final bool archived;
  final bool shareable;

  BookResponse({
    required this.id,
    required this.title,
    required this.authorName,
    required this.isbn,
    required this.synopsis,
    required this.owner,
    required this.cover,
    required this.rate,
    required this.archived,
    required this.shareable,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      id: json['id'],
      title: json['title'],
      authorName: json['authorName'],
      isbn: json['isbn'],
      synopsis: json['synopsis'],
      owner: json['owner'],
      cover: json['cover'],
      rate: json['rate'],
      archived: json['archived'],
      shareable: json['shareable'],
    );
  }
}
