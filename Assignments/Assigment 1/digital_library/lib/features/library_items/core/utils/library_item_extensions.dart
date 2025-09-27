import '../../data/repositories/json_library_repository.dart';
import '../../domain/entities/audiobook.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/library_item.dart';

extension LibraryItemExt on List<LibraryItem> {
  List<LibraryItem> filterByAuthor(String authorName) {
    return where(
      (item) => item.authors.any(
        (author) =>
            author.name.toLowerCase().contains(authorName.toLowerCase()),
      ),
    ).toList();
  }

  List<LibraryItem> filterByCategory(String category) {
    return where(
      (item) => item.category.toLowerCase() == category.toLowerCase(),
    ).toList();
  }

  List<LibraryItem> sortByRating() {
    return [];
  }

  Map<String, List<LibraryItem>> groupByCategory() {
    return fold({}, (Map<String, List<LibraryItem>> acc, item) {
      acc.putIfAbsent(item.category, () => []).add(item);
      return acc;
    });
  }

  Future<List<LibraryItem>> findSimilarItems(
    LibraryItem item,
    int maxResults,
  ) async {
    var repo = JsonLibraryRepository();
    var allItems = await repo.getAllItems();
    allItems.removeWhere((i) => i.id == item.id);
    return allItems
        .where(
          (i) =>
              i.category == item.category ||
              i.authors.any((a) => item.authors.contains(a)),
        )
        .take(maxResults)
        .toList();
  }

  double getReadingTimeEstimate() {
    return fold(
      0,
      (sum, item) => item is Book
          ? sum + item.pageCount * 250 / 200
          : sum + (item as Audiobook).duration,
    );
  }

  Future<Map<String, dynamic>> analyzeCollectionHealth() async {
    var totalItems = length;
    var availableItems = where((item) => item.isAvailable).length;
    var borrowedItems = totalItems - availableItems;
    var utilizationRate = totalItems > 0
        ? (borrowedItems / totalItems) * 100
        : 0.0;

    var categories = <String, int>{};
    var authorSet = <String>{};

    for (var item in this) {
      categories[item.category] = (categories[item.category] ?? 0) + 1;
      for (var author in item.authors) {
        authorSet.add(author.id);
      }
    }

    return {
      'totalItems': totalItems,
      'availableItems': availableItems,
      'borrowedItems': borrowedItems,
      'utilizationRate': utilizationRate,
      'categoryCount': categories.length,
      'authorCount': authorSet.length,
      'averageItemsPerCategory': categories.isNotEmpty
          ? totalItems / categories.length
          : 0.0,
      'categories': categories,
    };
  }

  double getPopularityScore() {
    if (isEmpty) return 0.0;

    return fold(0.0, (sum, item) {
          if (item is Book) {
            double reviewWeight = item.getReviewCount() * 0.3;
            double ratingWeight = item.getAverageRating() * 0.7;
            return sum + (reviewWeight + ratingWeight);
          } else if (item is Audiobook) {
            double reviewWeight = item.getReviewCount() * 0.3;
            double ratingWeight = item.getAverageRating() * 0.7;
            return sum + (reviewWeight + ratingWeight);
          }

          return sum;
        }) /
        length;
  }
}
