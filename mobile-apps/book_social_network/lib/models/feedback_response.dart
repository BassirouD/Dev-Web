class FeedbackResponse {
  final double note;
  final String comment;
  final bool ownFeedback;

  FeedbackResponse({
    required this.note,
    required this.comment,
    required this.ownFeedback,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      note: json['note'],
      comment: json['comment'],
      ownFeedback: json['ownFeedback'],
    );
  }
}
