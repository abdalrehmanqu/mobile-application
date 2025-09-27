import '../mixins/reviewable.dart';
import 'author.dart';
import 'library_item.dart';

class Audiobook extends LibraryItem with Reviewable {
  double duration;
  String narrator;
  double fileSize;

  Audiobook({
    required String id,
    required String title,
    required List<Author> authors,
    required int publishedYear,
    required String category,
    required bool isAvailable,
    this.duration = 0.0,
    this.narrator = '',
    this.fileSize = 0.0,
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
    return 'Audiobook';
  }

  @override
  String getDisplayInfo() {
    return '$title by ${authors.join(', ')} narrated by $narrator ($publishedYear)';
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
      'duration': duration,
      'narrator': narrator,
    };
  }

  factory Audiobook.fromJson(Map<String, dynamic> json, List<Author> authors) {
    return Audiobook(
      id: json['id'],
      title: json['title'],
      authors: authors,
      publishedYear: json['publishedYear'],
      category: json['category'],
      isAvailable: json['isAvailable'],
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      narrator: json['narrator'] ?? '',
      fileSize: (json['fileSize'] as num?)?.toDouble() ?? 0.0,
      coverImageUrl: json['coverImageUrl'],
      description: json['description'],
    );
  }
}
