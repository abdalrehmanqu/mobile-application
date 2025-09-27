import 'author.dart';
import 'book.dart';
import 'audiobook.dart';

abstract class LibraryItem {
  String id;
  String title;
  List<Author> authors = [];
  int publishedYear;
  String category;
  bool isAvailable;
  String? coverImageUrl;
  String? description;

  LibraryItem({
    required this.id,
    required this.title,
    required this.authors,
    required this.publishedYear,
    required this.category,
    required this.isAvailable,
    this.coverImageUrl,
    this.description,
  });

  String getItemType();
  String getDisplayInfo();

  Map<String, dynamic> toJson();
  factory LibraryItem.fromJson(
    Map<String, dynamic> json,
    List<Author> authors,
  ) {
    switch (json['type']) {
      case 'Book':
        return Book.fromJson(json, authors);
      case 'AudioBook':
      case 'Audiobook':
        return Audiobook.fromJson(json, authors);
      default:
        throw UnsupportedError('Unknown item type: ${json['type']}');
    }
  }
}
