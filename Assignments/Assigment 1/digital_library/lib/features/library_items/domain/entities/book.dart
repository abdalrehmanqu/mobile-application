import '../mixins/reviewable.dart';
import 'author.dart';
import 'library_item.dart';

class Book extends LibraryItem with Reviewable{
  int pageCount;
  String isbn;
  String publisher;

  Book({
    required String id,
    required String title,
    required List<Author> authors,
    required int publishedYear,
    required String category,
    required bool isAvailable,
    this.pageCount = 0,
    this.isbn = '',
    this.publisher = '',
    String? coverImageUrl,
    String? description,
  }) : super(
         id: id,
         title: title,
         authors: authors,
         publishedYear: publishedYear,
         category: category,
         isAvailable: isAvailable,
         coverImageUrl: coverImageUrl,
         description: description,
       );

  @override
  String getItemType() {
    return 'Book';
  }

  @override
  String getDisplayInfo() {
    return '$title by ${authors.join(', ')} ($publishedYear)';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'publishedYear': publishedYear,
      'category': category,
      'isAvailable': isAvailable,
      'coverImageUrl': coverImageUrl,
      'description': description,
      'pageCount': pageCount,
      'isbn': isbn,
      'publisher': publisher,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json, List<Author> authors) {
    return Book(
      id: json['id'],
      title: json['title'],
      authors: authors,
      publishedYear: json['publishedYear'],
      category: json['category'],
      isAvailable: json['isAvailable'],
      coverImageUrl: json['coverImageUrl'],
      description: json['description'],
      pageCount: json['pageCount'] ?? 0,
      isbn: json['isbn'] ?? '',
      publisher: json['publisher'] ?? '',
    );
  }

}
