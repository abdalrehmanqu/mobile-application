import 'dart:math';
import '../lib/features/library_items/core/utils/library_item_extensions.dart';
import '../lib/features/library_items/data/repositories/json_library_repository.dart';
import '../lib/features/library_items/domain/entities/library_item.dart';
import '../lib/features/library_items/domain/entities/book.dart';
import '../lib/features/library_items/domain/entities/audiobook.dart';
import '../lib/features/library_items/domain/entities/author.dart';
import '../lib/features/members/data/repositories/json_member_repository.dart';
import '../lib/features/members/domain/entities/member.dart';
import '../lib/features/members/domain/entities/student_member.dart';
import '../lib/features/members/domain/entities/faculty_member.dart';
import '../lib/features/borrowing/domain/entities/review.dart';
import '../lib/features/borrowing/domain/entities/borrowed_item.dart';
import '../lib/features/borrowing/domain/services/library_system.dart';

void main() async {
  print('🏛️  Digital Library Management System - Comprehensive Testing');
  print('=' * 70);

  try {
    final libraryRepo = JsonLibraryRepository();
    final memberRepo = JsonMemberRepository();
    final librarySystem = LibrarySystem(libraryRepo, memberRepo);

    await testLibraryItems(libraryRepo);

    await testMembers(memberRepo);

    await testSystemIntegration(librarySystem, libraryRepo, memberRepo);

    await testErrorHandling(librarySystem, libraryRepo, memberRepo);

    print('\n🎉 All tests completed successfully!');
  } catch (e) {
    print('❌ Error during testing: $e');
  }
}

Future<void> testLibraryItems(JsonLibraryRepository libraryRepo) async {
  print('\n LIBRARY ITEMS TESTING');
  print('-' * 50);

  print('\n1. Loading different item types from JSON arrays:');
  final allItems = await libraryRepo.getAllItems();
  print('   Total items loaded: ${allItems.length}');

  final books = allItems.whereType<Book>().toList();
  final audiobooks = allItems.whereType<Audiobook>().toList();

  print('   Books: ${books.length}');
  print('   Audiobooks: ${audiobooks.length}');

  if (books.isNotEmpty) {
    print(
      '   Sample Book: "${books.first.title}" by ${books.first.authors.map((a) => a.name).join(', ')}',
    );
    print(
      '   Book details: ${books.first.pageCount} pages, ISBN: ${books.first.isbn}',
    );
  }

  if (audiobooks.isNotEmpty) {
    print(
      '   Sample Audiobook: "${audiobooks.first.title}" narrated by ${audiobooks.first.narrator}',
    );
    print(
      '   Audiobook details: ${audiobooks.first.duration} hours, ${audiobooks.first.fileSize} MB',
    );
  }

  print('\n2. Search functionality with partial matches:');
  final searchResults = await libraryRepo.searchItems('data');
  print('   Search for "data": ${searchResults.length} results');
  for (var item in searchResults.take(3)) {
    print('   - ${item.title} (${item.getItemType()})');
  }

  final authorSearchResults = await libraryRepo.searchItems('johnson');
  print('   Search for "johnson": ${authorSearchResults.length} results');
  for (var item in authorSearchResults.take(2)) {
    print(
      '   - ${item.title} by ${item.authors.map((a) => a.name).join(', ')}',
    );
  }

  print('\n3. Category filtering and sorting:');
  final categories = allItems.map((item) => item.category).toSet().toList();
  print('   Available categories: ${categories.join(', ')}');

  for (var category in categories.take(3)) {
    final categoryItems = await libraryRepo.getItemsByCategory(category);
    print('   $category: ${categoryItems.length} items');

    categoryItems.sort((a, b) => b.publishedYear.compareTo(a.publishedYear));
    if (categoryItems.isNotEmpty) {
      print(
        '     Latest: ${categoryItems.first.title} (${categoryItems.first.publishedYear})',
      );
    }
  }

  print('\n4. Review system with multiple reviews per item:');

  for (int i = 0; i < min(5, allItems.length); i++) {
    var item = allItems[i];
    if (item is Book || item is Audiobook) {
      var reviewable = item as dynamic;

      reviewable.addReview(
        Review(
          rating: Random().nextInt(3) + 3,
          comment: 'Excellent resource for learning. Highly recommended!',
          reviewerName: 'Dr. Smith',
          reviewDate: DateTime.now().subtract(
            Duration(days: Random().nextInt(30)),
          ),
          itemId: item.id,
        ),
      );

      reviewable.addReview(
        Review(
          rating: Random().nextInt(2) + 4,
          comment: 'Very comprehensive and well-structured content.',
          reviewerName: 'Prof. Johnson',
          reviewDate: DateTime.now().subtract(
            Duration(days: Random().nextInt(60)),
          ),
          itemId: item.id,
        ),
      );

      reviewable.addReview(
        Review(
          rating: Random().nextInt(4) + 2,
          comment: 'Good material but could use more practical examples.',
          reviewerName: 'Student A',
          reviewDate: DateTime.now().subtract(
            Duration(days: Random().nextInt(90)),
          ),
          itemId: item.id,
        ),
      );

      print('   ${item.title}:');
      print('     Reviews: ${reviewable.getReviewCount()}');
      print(
        '     Average Rating: ${reviewable.getAverageRating().toStringAsFixed(2)}/5.0',
      );

      var topReviews = reviewable.getTopReviews(2);
      for (var review in topReviews) {
        print(
          '     - ${review.rating}★ by ${review.reviewerName}: "${review.comment.substring(0, min(50, review.comment.length))}..."',
        );
      }
    }
  }

  print('\n5. Popularity scoring and similar items finding:');

  var itemsWithScores = allItems
      .where((item) {
        if (item is Book) return item.reviews.isNotEmpty;
        if (item is Audiobook) return item.reviews.isNotEmpty;
        return false;
      })
      .map((item) {
        var reviewable = item as dynamic;
        var avgRating = reviewable.getAverageRating();
        var reviewCount = reviewable.getReviewCount();
        var availabilityBonus = item.isAvailable ? 0.5 : 0.0;
        var popularityScore =
            avgRating * 0.7 + reviewCount * 0.2 + availabilityBonus;
        return {'item': item, 'score': popularityScore};
      })
      .toList();

  itemsWithScores.sort(
    (a, b) => (b['score'] as double).compareTo(a['score'] as double),
  );

  print('   Top 3 most popular items:');
  for (int i = 0; i < min(3, itemsWithScores.length); i++) {
    var entry = itemsWithScores[i];
    var item = entry['item'] as LibraryItem;
    var score = entry['score'] as double;
    print('   ${i + 1}. ${item.title} (Score: ${score.toStringAsFixed(2)})');
  }

  if (itemsWithScores.isNotEmpty) {
    var topItem = itemsWithScores.first['item'] as LibraryItem;
    print('\n   Similar items to "${topItem.title}":');

    var similarByCategory = await libraryRepo.getItemsByCategory(
      topItem.category,
    );
    similarByCategory.removeWhere((item) => item.id == topItem.id);

    print(
      '     Same category (${topItem.category}): ${min(3, similarByCategory.length)} items',
    );
    for (var item in similarByCategory.take(3)) {
      print('     - ${item.title}');
    }

    if (topItem.authors.isNotEmpty) {
      var similarByAuthor = await libraryRepo.getItemsByAuthor(
        topItem.authors.first.id,
      );
      similarByAuthor.removeWhere((item) => item.id == topItem.id);

      print('     Same author: ${min(2, similarByAuthor.length)} items');
      for (var item in similarByAuthor.take(2)) {
        print('     - ${item.title}');
      }
    }
  }

  print('\n6. Collection health analysis:');
  final items = await libraryRepo.getAllItems();
  final healthAnalysis = await items.analyzeCollectionHealth();

  print('   Collection Overview:');
  print('     Total Items: ${healthAnalysis['totalItems']}');
  print('     Available: ${healthAnalysis['availableItems']}');
  print('     Currently Borrowed: ${healthAnalysis['borrowedItems']}');
  print(
    '     Utilization Rate: ${healthAnalysis['utilizationRate'].toStringAsFixed(1)}%',
  );
  print('     Categories: ${healthAnalysis['categoryCount']}');
  print('     Authors: ${healthAnalysis['authorCount']}');
  print(
    '     Avg Items per Category: ${healthAnalysis['averageItemsPerCategory'].toStringAsFixed(1)}',
  );

  print('   Top Categories by Item Count:');
  var categoryMap = healthAnalysis['categories'] as Map<String, int>;
  var sortedCategories = categoryMap.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  for (var entry in sortedCategories.take(5)) {
    print('     ${entry.key}: ${entry.value} items');
  }

  print('✅ Library Items Testing Completed');
}

Future<void> testMembers(JsonMemberRepository memberRepo) async {
  print('\n👥 MEMBERS TESTING');
  print('-' * 50);

  print('\n1. Creating different member types with specific limits:');

  final allMembers = await memberRepo.getAllMembers();
  print('   Total members loaded: ${allMembers.length}');

  final students = allMembers.whereType<StudentMember>().toList();
  final faculty = allMembers.whereType<FacultyMember>().toList();

  print('   Students: ${students.length}');
  print('   Faculty: ${faculty.length}');

  if (students.isNotEmpty) {
    var student = students.first;
    print('   Sample Student: ${student.name}');
    print('     Max Borrow Limit: ${student.maxBorrowLimit} items');
    print('     Borrow Period: ${student.borrowPeriod} days');
    print('     Student ID: ${student.studentId}');
  }

  if (faculty.isNotEmpty) {
    var facultyMember = faculty.first;
    print('   Sample Faculty: ${facultyMember.name}');
    print('     Max Borrow Limit: ${facultyMember.maxBorrowLimit} items');
    print('     Borrow Period: ${facultyMember.borrowPeriod} days');
    print('     Department: ${facultyMember.department}');
  }

  print('\n2. Test borrowing eligibility validation:');

  var mockItem = Book(
    id: 'test001',
    title: 'Test Book',
    authors: [Author(id: 'auth999', name: 'Test Author')],
    publishedYear: 2024,
    category: 'Test',
    isAvailable: true,
  );

  if (students.isNotEmpty) {
    var student = students.first;
    print('   Testing student borrowing eligibility:');
    print('     Can borrow available item: ${student.canBorrowItem(mockItem)}');

    mockItem.isAvailable = false;
    print(
      '     Can borrow unavailable item: ${student.canBorrowItem(mockItem)}',
    );
    mockItem.isAvailable = true;

    student.borrowedItems.add(
      BorrowedItem(
        item: mockItem,
        borrowDate: DateTime.now().subtract(Duration(days: 20)),
        dueDate: DateTime.now().subtract(Duration(days: 5)),
      ),
    );
    print(
      '     Can borrow with overdue items: ${student.canBorrowItem(mockItem)}',
    );
  }

  if (faculty.isNotEmpty) {
    var facultyMember = faculty.first;
    print('   Testing faculty borrowing eligibility:');
    print(
      '     Can borrow available item: ${facultyMember.canBorrowItem(mockItem)}',
    );

    mockItem.isAvailable = false;
    print(
      '     Can borrow unavailable item: ${facultyMember.canBorrowItem(mockItem)}',
    );
    mockItem.isAvailable = true;
  }

  print('\n3. Demonstrate member type polymorphism:');

  List<Member> mixedMembers = [...students.take(2), ...faculty.take(2)];

  for (var member in mixedMembers) {
    print('   Member: ${member.name} (${member.getMemberType()})');
    print(
      '     Max Limit: ${member.maxBorrowLimit}, Period: ${member.borrowPeriod} days',
    );

    var summary = member.getMembershipSummary();
    print(
      '     Join Date: ${DateTime.parse(summary['Join Date'] as String).year}',
    );
    print('     Current Borrowed: ${summary['Current Borrowed Items']}');
  }

  print('\n4. Fee calculation and payment processing:');

  if (students.isNotEmpty) {
    var student = students.first;

    student.borrowedItems.clear();

    student.borrowedItems.add(
      BorrowedItem(
        item: Book(
          id: 'test1',
          title: 'Book 1',
          authors: [],
          publishedYear: 2024,
          category: 'Test',
          isAvailable: false,
        ),
        borrowDate: DateTime.now().subtract(Duration(days: 30)),
        dueDate: DateTime.now().subtract(Duration(days: 10)),
      ),
    );

    student.borrowedItems.add(
      BorrowedItem(
        item: Book(
          id: 'test2',
          title: 'Book 2',
          authors: [],
          publishedYear: 2024,
          category: 'Test',
          isAvailable: false,
        ),
        borrowDate: DateTime.now().subtract(Duration(days: 25)),
        dueDate: DateTime.now().subtract(Duration(days: 3)),
      ),
    );

    print('   Student fee calculation:');
    print('     Overdue items: ${student.getOverdueItems().length}');

    for (var item in student.getOverdueItems()) {
      print(
        '     - "${item.item.title}": ${item.getDaysOverdue()} days overdue, Fine: \$${item.calculateFine(2.0).toStringAsFixed(2)}',
      );
    }

    var totalFees = student.calculateFees();
    print('     Total fees: \$${totalFees.toStringAsFixed(2)}');

    print('     Payment test:');
    print(
      '       Pay \$10.00: ${student.payFees(10.00) ? 'Success' : 'Insufficient'}',
    );
    print(
      '       Pay \$50.00: ${student.payFees(50.00) ? 'Success' : 'Insufficient'}',
    );
    print(
      '       Pay total amount: ${student.payFees(totalFees) ? 'Success' : 'Insufficient'}',
    );
  }

  print('✅ Members Testing Completed');
}

Future<void> testSystemIntegration(
  LibrarySystem librarySystem,
  JsonLibraryRepository libraryRepo,
  JsonMemberRepository memberRepo,
) async {
  print('\n SYSTEM INTEGRATION TESTING');
  print('-' * 50);

  final allMembers = await memberRepo.getAllMembers();
  final allItems = await libraryRepo.getAllItems();

  if (allMembers.isEmpty || allItems.isEmpty) {
    print('❌ No members or items available for integration testing');
    return;
  }

  print('\n1. Complete borrowing workflow with validation:');

  var testMember = allMembers.first;
  var testItem = allItems.where((item) => item.isAvailable).first;

  print('   Member: ${testMember.name} (${testMember.getMemberType()})');
  print('   Item: ${testItem.title}');
  print('   Initial availability: ${testItem.isAvailable}');

  var borrowResult = await librarySystem.borrowItem(
    testMember.memberId,
    testItem.id,
  );
  print('   Borrow attempt: ${borrowResult ? 'Success' : 'Failed'}');

  if (borrowResult) {
    var updatedMember = await memberRepo.getMember(testMember.memberId);
    if (updatedMember != null) {
      testMember = updatedMember;
    }

    print('   Item availability after borrow: ${testItem.isAvailable}');
    print('   Member borrowed items: ${testMember.borrowedItems.length}');

    if (testMember.borrowedItems.isNotEmpty) {
      var borrowedItem = testMember.borrowedItems.last;
      print('   Borrow details:');
      print(
        '     Borrow Date: ${borrowedItem.borrowDate.toString().substring(0, 19)}',
      );
      print(
        '     Due Date: ${borrowedItem.dueDate.toString().substring(0, 19)}',
      );
      print('     Is Returned: ${borrowedItem.isReturned}');
    }
  }

  print('\n2. Return processing with fee calculation:');

  if (testMember.borrowedItems.isNotEmpty) {
    var borrowedItem = testMember.borrowedItems.last;

    borrowedItem.dueDate = DateTime.now().subtract(Duration(days: 5));

    print('   Processing return for overdue item:');
    print('   Days overdue: ${borrowedItem.getDaysOverdue()}');

    if (testMember is StudentMember) {
      var feeBeforeReturn = testMember.calculateFees();
      print('   Fee before return: \$${feeBeforeReturn.toStringAsFixed(2)}');
    }

    var returnResult = await librarySystem.returnItem(
      testMember.memberId,
      testItem.id,
    );
    print('   Return result: ${returnResult ? 'Success' : 'Failed'}');

    if (returnResult) {
      print('   Item availability after return: ${testItem.isAvailable}');
      print(
        '   Return date: ${borrowedItem.returnDate?.toString().substring(0, 19)}',
      );
    }
  } else {
    print('   No borrowed items found for return test');
  }

  print('\n3. Overdue report generation:');

  for (int i = 0; i < min(3, allMembers.length); i++) {
    var member = allMembers[i];
    if (i < allItems.length) {
      member.borrowedItems.add(
        BorrowedItem(
          item: allItems[i],
          borrowDate: DateTime.now().subtract(Duration(days: 30 + i * 5)),
          dueDate: DateTime.now().subtract(Duration(days: i + 1)),
        ),
      );
    }
  }

  var overdueReport = await librarySystem.generateOverdueReport();
  print('   Overdue items found: ${overdueReport.length}');

  for (var report in overdueReport.take(5)) {
    print('   - $report');
  }

  print('\n4. Item recommendation system:');

  if (allMembers.isNotEmpty && allItems.length >= 5) {
    var member = allMembers.first;

    member.borrowedItems.clear();
    member.borrowedItems.addAll([
      BorrowedItem(
        item: allItems[0],
        borrowDate: DateTime.now().subtract(Duration(days: 60)),
        dueDate: DateTime.now().subtract(Duration(days: 46)),
        isReturned: true,
        returnDate: DateTime.now().subtract(Duration(days: 45)),
      ),
      BorrowedItem(
        item: allItems[1],
        borrowDate: DateTime.now().subtract(Duration(days: 30)),
        dueDate: DateTime.now().subtract(Duration(days: 16)),
        isReturned: true,
        returnDate: DateTime.now().subtract(Duration(days: 15)),
      ),
    ]);

    print('   Generating recommendations for: ${member.name}');
    print(
      '   Based on ${member.getBorrowingHistory().length} previously borrowed items',
    );

    var recommendations = await librarySystem.recommendItems(
      member.memberId,
      5,
    );
    print('   Recommendations (${recommendations.length} items):');

    for (int i = 0; i < recommendations.length; i++) {
      var item = recommendations[i];
      var reviewable = item as dynamic;
      var rating = (item is Book || item is Audiobook)
          ? (reviewable.getReviewCount() > 0
                ? reviewable.getAverageRating()
                : 0.0)
          : 0.0;
      print(
        '   ${i + 1}. ${item.title} (${item.category}) - Rating: ${rating.toStringAsFixed(1)}/5',
      );
    }
  }

  print('\n5. Monthly analytics report:');

  final freshMembers = await memberRepo.getAllMembers();
  if (freshMembers.length >= 3 && allItems.length >= 5) {
    print('   Adding sample borrowing data for analytics demonstration...');
    for (int i = 0; i < 3; i++) {
      var member = freshMembers[i];
      member.borrowedItems.clear();

      for (int j = 0; j < min(3, allItems.length); j++) {
        if (i * 3 + j < allItems.length) {
          var item = allItems[i * 3 + j];
          var borrowDate = DateTime(2025, 8, 10 + j * 5);
          var dueDate = borrowDate.add(Duration(days: member.borrowPeriod));
          var returnDate = j < 2 ? DateTime(2025, 8, 20 + j * 5) : null;

          member.borrowedItems.add(
            BorrowedItem(
              item: item,
              borrowDate: borrowDate,
              dueDate: dueDate,
              returnDate: returnDate,
              isReturned: j < 2,
            ),
          );

          if (j == 0) {
            var julyBorrowDate = DateTime(2025, 7, 15 + i * 3);
            var julyDueDate = julyBorrowDate.add(
              Duration(days: member.borrowPeriod),
            );
            member.borrowedItems.add(
              BorrowedItem(
                item: item,
                borrowDate: julyBorrowDate,
                dueDate: julyDueDate,
                returnDate: DateTime(2025, 7, 25 + i * 3),
                isReturned: true,
              ),
            );
          }
        }
      }
      print(
        '   Member ${member.name} now has ${member.borrowedItems.length} borrowing records',
      );
    }
  }

  var analyticsReport = await generateCustomMonthlyReport(
    freshMembers,
    allItems,
  );

  print('   Monthly Report for: ${analyticsReport['month']}');

  var totals = analyticsReport['totals'] as Map<String, dynamic>;
  print('   Summary:');
  print('     Total Borrows: ${totals['borrows']}');
  print('     Total Returns: ${totals['returns']}');
  print(
    '     Revenue (QAR): ${(totals['revenueQar'] as double).toStringAsFixed(2)}',
  );

  var trends = analyticsReport['trends'] as Map<String, dynamic>;
  var changePercent = (trends['borrowsChangePct'] as double);
  var changeSign = changePercent > 0 ? '+' : '';
  print('     Growth Rate: ${changeSign}${changePercent.toStringAsFixed(1)}%');

  var popularItems = analyticsReport['popularItems'] as List;
  print('   Most Popular Items:');
  if (popularItems.isEmpty) {
    print('     No borrowing activity found in this period');
  } else {
    for (int i = 0; i < min(3, popularItems.length); i++) {
      var item = popularItems[i];
      var rating = (item['avgRating'] as double).toStringAsFixed(1);
      var borrowCount = item['borrows'];
      print(
        '     ${i + 1}. ${item['title']} - ${borrowCount} borrow${borrowCount == 1 ? '' : 's'}, ${rating}/5.0 rating',
      );
    }
  }

  var activeMembers = analyticsReport['activeMembers'] as List;
  print('   Most Active Members:');
  if (activeMembers.isEmpty) {
    print('     No member activity found in this period');
  } else {
    for (int i = 0; i < min(3, activeMembers.length); i++) {
      var member = activeMembers[i];
      var transactions = member['transactions'];
      print(
        '     ${i + 1}. ${member['name']} - ${transactions} transaction${transactions == 1 ? '' : 's'}',
      );
    }
  }

  print('✅ System Integration Testing Completed');
}

Future<void> testErrorHandling(
  LibrarySystem librarySystem,
  JsonLibraryRepository libraryRepo,
  JsonMemberRepository memberRepo,
) async {
  print('\n  ERROR HANDLING TESTING');
  print('-' * 50);

  print('\n1. Testing invalid member/item IDs:');

  try {
    var result = await librarySystem.borrowItem('INVALID_MEMBER', 'book001');
    print(
      '   Borrow with invalid member ID: ${result ? 'Unexpected Success' : 'Correctly Failed'}',
    );
  } catch (e) {
    print(
      '   Borrow with invalid member ID: Exception caught - ${e.toString().substring(0, min(50, e.toString().length))}...',
    );
  }

  try {
    var item = await libraryRepo.getItem('INVALID_ITEM_ID');
    print(
      '   Get invalid item: ${item == null ? 'Correctly returned null' : 'Unexpected result'}',
    );
  } catch (e) {
    print('   Get invalid item: Exception caught - ${e.toString()}');
  }

  try {
    var member = await memberRepo.getMember('INVALID_MEMBER_ID');
    print(
      '   Get invalid member: ${member == null ? 'Correctly returned null' : 'Unexpected result'}',
    );
  } catch (e) {
    print('   Get invalid member: Exception caught - ${e.toString()}');
  }

  print('\n2. Testing exceeded borrowing limits:');

  final allMembers = await memberRepo.getAllMembers();
  final allItems = await libraryRepo.getAllItems();

  if (allMembers.isNotEmpty && allItems.isNotEmpty) {
    var testMember = allMembers.first;

    testMember.borrowedItems.clear();
    for (int i = 0; i < testMember.maxBorrowLimit; i++) {
      if (i < allItems.length) {
        testMember.borrowedItems.add(
          BorrowedItem(
            item: allItems[i],
            borrowDate: DateTime.now(),
            dueDate: DateTime.now().add(Duration(days: 14)),
          ),
        );
      }
    }

    print(
      '   Member ${testMember.name} has ${testMember.borrowedItems.length}/${testMember.maxBorrowLimit} items borrowed',
    );

    if (allItems.length > testMember.maxBorrowLimit) {
      var extraItem = allItems[testMember.maxBorrowLimit];
      var canBorrow = testMember.canBorrowItem(extraItem);
      print(
        '   Attempt to exceed limit: ${canBorrow ? 'Unexpected Success' : 'Correctly Prevented'}',
      );
    }
  }

  print('\n3. Testing borrowing unavailable items:');

  if (allItems.isNotEmpty && allMembers.isNotEmpty) {
    var unavailableItem = allItems.firstWhere(
      (item) => !item.isAvailable,
      orElse: () => allItems.first..isAvailable = false,
    );

    var testMember = allMembers.first;
    print('   Attempting to borrow unavailable item: ${unavailableItem.title}');

    var borrowResult = await librarySystem.borrowItem(
      testMember.memberId,
      unavailableItem.id,
    );
    print(
      '   Borrow unavailable item result: ${borrowResult ? 'Unexpected Success' : 'Correctly Failed'}',
    );

    var canBorrow = testMember.canBorrowItem(unavailableItem);
    print(
      '   Can borrow check: ${canBorrow ? 'Unexpected True' : 'Correctly False'}',
    );
  }

  print('\n4. Testing duplicate review prevention:');

  if (allItems.isNotEmpty) {
    var testItem = allItems.firstWhere(
      (item) => item is Book || item is Audiobook,
      orElse: () => allItems.first,
    );

    if (testItem is Book || testItem is Audiobook) {
      var reviewable = testItem as dynamic;

      reviewable.reviews.clear();

      var testReview = Review(
        rating: 5,
        comment: 'Great book!',
        reviewerName: 'Test User',
        reviewDate: DateTime.now(),
        itemId: testItem.id,
      );

      reviewable.addReview(testReview);
      print(
        '   First review added. Total reviews: ${reviewable.getReviewCount()}',
      );

      var duplicateReview = Review(
        rating: 4,
        comment: 'Different comment, same user',
        reviewerName: 'Test User',
        reviewDate: DateTime.now(),
        itemId: testItem.id,
      );

      reviewable.addReview(duplicateReview);
      print(
        '   Attempted duplicate review. Total reviews: ${reviewable.getReviewCount()}',
      );
      print(
        '   Duplicate prevention: ${reviewable.getReviewCount() == 1 ? 'Working' : 'Failed'}',
      );
    }
  }

  print('\n5. Testing invalid payment amounts:');

  if (allMembers.isNotEmpty) {
    var students = allMembers.whereType<StudentMember>().toList();

    if (students.isNotEmpty) {
      var student = students.first;

      student.borrowedItems.clear();
      student.borrowedItems.add(
        BorrowedItem(
          item: allItems.first,
          borrowDate: DateTime.now().subtract(Duration(days: 30)),
          dueDate: DateTime.now().subtract(Duration(days: 10)),
        ),
      );

      var totalFees = student.calculateFees();
      print('   Student owes: \$${totalFees.toStringAsFixed(2)}');

      print('   Payment tests:');

      try {
        var result = student.payFees(-10.0);
        print(
          '     Pay negative amount (-\$10): ${result ? 'Unexpected Success' : 'Correctly Failed'}',
        );
      } catch (e) {
        print('     Pay negative amount: Exception caught');
      }

      var zeroResult = student.payFees(0.0);
      print(
        '     Pay zero amount: ${zeroResult ? 'Unexpected Success' : 'Correctly Failed'}',
      );

      var insufficientResult = student.payFees(totalFees - 1.0);
      print(
        '     Pay insufficient amount: ${insufficientResult ? 'Unexpected Success' : 'Correctly Failed'}',
      );

      var exactResult = student.payFees(totalFees);
      print(
        '     Pay exact amount: ${exactResult ? 'Success' : 'Unexpected Failure'}',
      );

      var overpayResult = student.payFees(totalFees + 10.0);
      print(
        '     Pay more than owed: ${overpayResult ? 'Success' : 'Unexpected Failure'}',
      );
    }
  }

  print('\n6. Testing reservation system errors:');

  if (allMembers.isNotEmpty && allItems.isNotEmpty) {
    var member = allMembers.first;
    var item = allItems.first;

    try {
      await librarySystem.handleReservation('INVALID_MEMBER', item.id);
      print('   Reserve with invalid member: Unexpected success');
    } catch (e) {
      print('   Reserve with invalid member: Correctly caught exception');
    }

    try {
      await librarySystem.handleReservation(member.memberId, 'INVALID_ITEM');
      print('   Reserve with invalid item: Unexpected success');
    } catch (e) {
      print('   Reserve with invalid item: Correctly caught exception');
    }

    var cancelResult = librarySystem.cancelReservation(
      member.memberId,
      item.id,
    );
    print(
      '   Cancel non-existent reservation: ${cancelResult ? 'Unexpected Success' : 'Correctly Failed'}',
    );
  }

  print('✅ Error Handling Testing Completed');
}

Future<Map<String, dynamic>> generateCustomMonthlyReport(
  List<Member> members,
  List<LibraryItem> items,
) async {
  final now = DateTime.now();
  final DateTime startLast = DateTime(now.year, now.month - 1, 1);
  final DateTime endLast = DateTime(now.year, now.month, 1);
  final DateTime prevStart = DateTime(startLast.year, startLast.month - 1, 1);
  final DateTime prevEnd = startLast;

  bool inRange(DateTime d, DateTime s, DateTime e) =>
      !d.isBefore(s) && d.isBefore(e);

  double avgRating(LibraryItem item) {
    if (item is Book) return item.getAverageRating();
    if (item is Audiobook) return item.getAverageRating();
    return 0.0;
  }

  int reviewCount(LibraryItem item) {
    if (item is Book) return item.getReviewCount();
    if (item is Audiobook) return item.getReviewCount();
    return 0;
  }

  double pctDelta(int prev, int curr) =>
      prev == 0 ? (curr == 0 ? 0.0 : 100.0) : ((curr - prev) / prev) * 100.0;

  final itemById = {for (final i in items) i.id: i};

  int borrowsThisMonth = 0;
  int returnsThisMonth = 0;
  int prevBorrows = 0;

  final borrowsPerItem = <String, int>{};
  final txPerMember = <String, int>{};
  final memberName = <String, String>{};

  double revenueQar = 0.0;

  for (final m in members) {
    memberName[m.memberId] = m.name;
    final hist = m.getBorrowingHistory();

    final borCurr = hist
        .where((b) => inRange(b.borrowDate, startLast, endLast))
        .toList();
    final retCurr = hist
        .where(
          (b) =>
              b.returnDate != null &&
              inRange(b.returnDate!, startLast, endLast),
        )
        .toList();

    borrowsThisMonth += borCurr.length;
    returnsThisMonth += retCurr.length;

    for (final b in borCurr) {
      borrowsPerItem.update(b.item.id, (v) => v + 1, ifAbsent: () => 1);
    }

    final tx = borCurr.length + retCurr.length;
    if (tx > 0) {
      txPerMember.update(m.memberId, (v) => v + tx, ifAbsent: () => tx);
    }

    for (final b in retCurr) {
      if (m is StudentMember && b.overdue()) {
        final fine = b.calculateFine(2.0);
        revenueQar += fine > 50.0 ? 50.0 : fine;
      }
    }

    prevBorrows += hist
        .where((b) => inRange(b.borrowDate, prevStart, prevEnd))
        .length;
  }

  final entries = borrowsPerItem.entries.toList()
    ..sort((a, b) {
      final ia = itemById[a.key]!;
      final ib = itemById[b.key]!;
      final r = avgRating(ib).compareTo(avgRating(ia));
      if (r != 0) return r;
      final c = b.value.compareTo(a.value);
      if (c != 0) return c;
      return reviewCount(ib).compareTo(reviewCount(ia));
    });

  const topN = 5;
  final popularItems = entries.take(topN).map((e) {
    final it = itemById[e.key]!;
    return {
      'itemId': it.id,
      'title': it.title,
      'category': it.category,
      'borrows': e.value,
      'avgRating': avgRating(it),
      'reviews': reviewCount(it),
    };
  }).toList();

  final activeMembers = txPerMember.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final activeMembersTop = activeMembers.take(topN).map((e) {
    return {
      'memberId': e.key,
      'name': memberName[e.key] ?? e.key,
      'transactions': e.value,
    };
  }).toList();

  final y = startLast.year;
  final mth = startLast.month.toString().padLeft(2, '0');
  return {
    'month': '$y-$mth',
    'totals': {
      'borrows': borrowsThisMonth,
      'returns': returnsThisMonth,
      'revenueQar': revenueQar,
    },
    'popularItems': popularItems,
    'activeMembers': activeMembersTop,
    'trends': {'borrowsChangePct': pctDelta(prevBorrows, borrowsThisMonth)},
  };
}
