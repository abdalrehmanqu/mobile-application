import 'dart:convert';
import 'dart:io';

import '../../domain/contracts/library_repository.dart';
import '../../domain/entities/author.dart';
import '../../domain/entities/library_item.dart';

class JsonLibraryRepository implements LibraryRepository {
  static List<LibraryItem> _itemsCache = [];
  static List<Author> _authorsCache = [];

  Future<void> loadData() async {
    if (_itemsCache.isNotEmpty) return;

    String itemsFileName = 'assets/data/library_catalog_json.json';
    File file = File(itemsFileName);
    String content = file.readAsStringSync();

    String authorsFileName = 'assets/data/authors_json.json';
    File authorsFile = File(authorsFileName);
    String authorsContent = authorsFile.readAsStringSync();

    var jsonAuthors = jsonDecode(authorsContent) as List;
    var authorMap = <String, Author>{};

    for (var authorJson in jsonAuthors) {
      var author = Author.fromJson(authorJson);
      authorMap[author.id] = author;
      if (!_authorsCache.any((a) => a.id == author.id)) {
        _authorsCache.add(author);
      }
    }

    var jsonItems = jsonDecode(content) as List;
    for (var item in jsonItems) {
      var authorIds = List<String>.from(item['authorIds'] ?? []);
      var itemAuthors = <Author>[];

      for (var authorId in authorIds) {
        if (authorMap.containsKey(authorId)) {
          itemAuthors.add(authorMap[authorId]!);
        }
      }

      _itemsCache.add(LibraryItem.fromJson(item, itemAuthors));
    }
  }

  Future<List<Author>> getAllAuthors() async {
    await loadData();
    return _authorsCache;
  }

  @override
  Future<List<LibraryItem>> getAllItems() async {
    await loadData();
    return _itemsCache;
  }

  @override
  Future<List<LibraryItem>> getAvailableItems() async {
    await loadData();
    return _itemsCache.where((item) => item.isAvailable).toList();
  }

  @override
  Future<LibraryItem?> getItem(String id) async {
    await loadData();
    try {
      return _itemsCache.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<LibraryItem>> getItemsByAuthor(String authorId) async {
    await loadData();
    return _itemsCache
        .where((item) => item.authors.any((author) => author.id == authorId))
        .toList();
  }

  @override
  Future<List<LibraryItem>> getItemsByCategory(String category) async {
    await loadData();
    return _itemsCache
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<List<LibraryItem>> searchItems(String query) async {
    await loadData();
    return _itemsCache
        .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getCollectionHealthAnalysis() async {
    await loadData();

    var totalItems = _itemsCache.length;
    var availableItems = _itemsCache.where((item) => item.isAvailable).length;
    var borrowedItems = totalItems - availableItems;
    var utilizationRate = totalItems > 0
        ? (borrowedItems / totalItems) * 100
        : 0.0;

    var categories = <String, int>{};
    var authorSet = <String>{};

    for (var item in _itemsCache) {
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
}
