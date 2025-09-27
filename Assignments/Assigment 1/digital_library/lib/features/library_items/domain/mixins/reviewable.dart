import '../../../borrowing/domain/entities/review.dart';

mixin Reviewable {
  List<Review> reviews = [];
  void addReview(Review review) {
    if (hasReviewsFromUser(review.reviewerName)) {
      return;
    }
    reviews.add(review);
  }

  double getAverageRating() {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }
  
  int getReviewCount() {
    return reviews.length;
  }

  getTopReviews(int count) {
    final sortedReviews = [...reviews]..sort((a, b) {
      final ratingComparison = b.rating.compareTo(a.rating);
      if (ratingComparison != 0) return ratingComparison;
      return b.reviewDate.compareTo(a.reviewDate);
    });
    return sortedReviews.take(count).toList();
  }

  bool hasReviewsFromUser(String userName){
    return reviews.any((r) => r.reviewerName == userName);
  }
}
