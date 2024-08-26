class FeedbackRequest {
  final double note;
  final String comment;
  final int bookId;

  FeedbackRequest(
      {required this.note, required this.comment, required this.bookId});

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'comment': comment,
      'bookId': bookId,
    };
  }
}
