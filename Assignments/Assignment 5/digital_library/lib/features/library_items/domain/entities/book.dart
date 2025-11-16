// Flat entity - only stores authorId, not Author object
class Book {
  final String id;
  final String title;
  final String authorId; // Foreign key - just the ID!
  final int publishedYear;
  final String category;
  final bool isAvailable;
  final String? coverImageUrl;
  final String? description;
  final int pageCount;
  final String isbn;
  final String publisher;

  Book({
    required this.id,
    required this.title,
    required this.authorId,
    required this.publishedYear,
    required this.category,
    required this.isAvailable,
    this.coverImageUrl,
    this.description,
    required this.pageCount,
    required this.isbn,
    required this.publisher,
  });

  String getItemType() => 'Book';

  factory Book.fromJson(Map<String, dynamic> json) {
    String readString(List<String> keys, String fieldName,
        {String? defaultValue}) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        return value.toString();
      }
      if (defaultValue != null) return defaultValue;
      throw FormatException('Missing "$fieldName" in book JSON data.');
    }

    String? readOptionalString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        return value.toString();
      }
      return null;
    }

    int readInt(List<String> keys, String fieldName) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        if (value is num) return value.toInt();
        if (value is String) {
          final parsed = int.tryParse(value);
          if (parsed != null) return parsed;
        }
      }
      throw FormatException('Missing "$fieldName" in book JSON data.');
    }

    bool readBool(List<String> keys, String fieldName,
        {bool defaultValue = false}) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        if (value is bool) return value;
        if (value is num) return value != 0;
        if (value is String) {
          final normalized = value.toLowerCase();
          if (normalized == 'true') return true;
          if (normalized == 'false') return false;
          final parsed = int.tryParse(value);
          if (parsed != null) return parsed != 0;
        }
      }
      return defaultValue;
    }

    String readAuthorId() {
      final value = readOptionalString([
        'authorId',
        'author_id',
        'authorID',
        'author',
        'author_name',
        'authorName',
      ]);
      if (value != null && value.isNotEmpty) return value;

      for (final key in ['authorIds', 'author_ids']) {
        final ids = json[key];
        if (ids is List && ids.isNotEmpty) {
          final first = ids.first;
          if (first != null) return first.toString();
        }
      }

      // Fallback to a placeholder rather than crashing the app
      return 'unknown-author';
    }

    return Book(
      id: readString(['id', 'book_id'], 'id'),
      title: readString(['title'], 'title'),
      authorId: readAuthorId(),
      publishedYear:
          readInt(['publishedYear', 'published_year'], 'publishedYear'),
      category: readString(['category'], 'category'),
      isAvailable: readBool(
        ['isAvailable', 'is_available'],
        'isAvailable',
        defaultValue: true,
      ),
      coverImageUrl:
          readOptionalString(['coverImageUrl', 'cover_image_url']),
      description: readOptionalString(['description']),
      pageCount: readInt(['pageCount', 'page_count'], 'pageCount'),
      isbn: readString(['isbn'], 'isbn'),
      publisher: readString(['publisher'], 'publisher'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'Book',
        'title': title,
        'author_id': authorId,
        'published_year': publishedYear,
        'category': category,
        'is_available': isAvailable,
        'cover_image_url': coverImageUrl,
        'description': description,
        'isbn': isbn,
        'page_count': pageCount,
        'publisher': publisher,
      };

  Book copyWith({
    String? id,
    String? title,
    String? authorId,
    int? publishedYear,
    String? category,
    bool? isAvailable,
    String? coverImageUrl,
    String? description,
    int? pageCount,
    String? isbn,
    String? publisher,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      publishedYear: publishedYear ?? this.publishedYear,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      description: description ?? this.description,
      pageCount: pageCount ?? this.pageCount,
      isbn: isbn ?? this.isbn,
      publisher: publisher ?? this.publisher,
    );
  }

  @override
  String toString() => 'Book(id: $id, title: $title, authorId: $authorId)';
}
