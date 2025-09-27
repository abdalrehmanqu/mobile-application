class Review {
  int rating;
  String comment;
  String reviewerName;
  DateTime reviewDate;
  String itemId;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    required this.reviewDate,
    required this.itemId,
  });

  bool isValidRating() {
    return rating >= 1 && rating <= 5;
  }

  int getWordCount() {
    return comment.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'reviewerName': reviewerName,
      'reviewDate': reviewDate.toIso8601String(),
      'itemId': itemId,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      reviewerName: json['reviewerName'],
      reviewDate: DateTime.parse(json['reviewDate']),
      itemId: json['itemId'],
    );
  }
}
