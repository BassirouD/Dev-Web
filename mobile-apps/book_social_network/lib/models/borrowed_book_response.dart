class BorrowedBookResponse {
  final int id;
  final String title;
  final String authorName;
  final String isbn;
  final double rate;
  final bool returned;
  final bool returnApproved;

  BorrowedBookResponse({
    required this.id,
    required this.title,
    required this.authorName,
    required this.isbn,
    required this.rate,
    required this.returned,
    required this.returnApproved,
  });
  // Méthode copyWith pour créer une copie de l'objet avec des valeurs mises à jour
  BorrowedBookResponse copyWith({
    int? id,
    String? title,
    String? authorName,
    String? isbn,
    double? rate,
    bool? returned,
    bool? returnApproved,
  }) {
    return BorrowedBookResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      isbn: isbn ?? this.isbn,
      rate: rate ?? this.rate,
      returned: returned ?? this.returned,
      returnApproved: returnApproved ?? this.returnApproved,
    );
  }

  factory BorrowedBookResponse.fromJson(Map<String, dynamic> json) {
    return BorrowedBookResponse(
      id: json['id'],
      title: json['title'],
      authorName: json['authorName'],
      isbn: json['isbn'],
      rate:
          json['rate']?.toDouble() ?? 0.0, // Convertir en double et gérer null
      returned: json['returned'] ?? false,
      returnApproved: json['returnApproved'] ?? false,
    );
  }
}
