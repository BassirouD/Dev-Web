class BookRequest {
  final String title;
  final String authorName;
  final String isbn;
  final String synopsis;
  final bool shareable;

  BookRequest({
    required this.title,
    required this.authorName,
    required this.isbn,
    required this.synopsis,
    required this.shareable,
  });

  // Méthode pour convertir le modèle en JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'authorName': authorName,
      'isbn': isbn,
      'synopsis': synopsis,
      'shareable': shareable,
    };
  }
}
