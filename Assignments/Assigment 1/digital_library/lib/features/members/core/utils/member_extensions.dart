import '../../../library_items/domain/entities/book.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/student_member.dart';

extension MemberExt on List<Member> {
List<T> filterByType<T extends Member>() {
  return whereType<T>().toList();
}

List<Member> getMembersWithOverdueItems() {
  return where((member) => member.borrowedItems.any((item) => 
    item.dueDate.isBefore(DateTime.now()))).toList();
}

double calculateTotalFees() {
  return fold(0.0, (sum, member) {
    if (member is StudentMember) {
      return sum + member.calculateFees();
    }
    return sum;
  });
}

Map<String, dynamic> analyzeBorrowingPatterns() {
  if (isEmpty) return {};
  
  final sortedByActivity = [...this]..sort((a, b) => 
    b.borrowedItems.length.compareTo(a.borrowedItems.length));
  
  final totalBooks = fold(0, (sum, member) => sum + member.borrowedItems.length);
  final avgBooksPerMember = totalBooks / length;
  
  final categoryCount = <String, Map<String, int>>{};
  for (final member in this) {
    final memberType = member.runtimeType.toString();
    categoryCount[memberType] ??= {};
    for (final item in member.borrowedItems) {
      final category = item is Book ? 'Book' : 'AudioBook';
      categoryCount[memberType]![category] = 
        (categoryCount[memberType]![category] ?? 0) + 1;
    }
  }
  
  return {
    'mostActiveMembers': sortedByActivity.take(5).toList(),
    'averageBooksPerMember': avgBooksPerMember,
    'popularCategoriesByType': categoryCount,
  };
}

List<Member> getMembersByActivity(DateTime since) {
  return where((member) => member.borrowedItems.any((item) => 
    item.borrowDate.isAfter(since))).toList();
}

List<Member> getRiskMembers(int overdueDaysThreshold) {
  final threshold = DateTime.now().subtract(Duration(days: overdueDaysThreshold));
  return where((member) => member.borrowedItems.any((item) => 
    item.dueDate.isBefore(threshold))).toList();
}

Map<String, dynamic> generateMembershipReport() {
  final typeDistribution = <String, int>{};
  final activityLevels = <String, List<Member>>{
    'high': [],
    'medium': [],
    'low': [],
  };
  
  double totalFees = 0.0;
  int totalBorrowedItems = 0;
  
  for (final member in this) {
    final memberType = member.runtimeType.toString();
    typeDistribution[memberType] = (typeDistribution[memberType] ?? 0) + 1;
    
    if (member is StudentMember) {
      totalFees += member.calculateFees();
    }
    totalBorrowedItems += member.borrowedItems.length;
    
    if (member.borrowedItems.length >= 5) {
      activityLevels['high']!.add(member);
    } else if (member.borrowedItems.length >= 2) {
      activityLevels['medium']!.add(member);
    } else {
      activityLevels['low']!.add(member);
    }
  }
  
  return {
    'memberTypeDistribution': typeDistribution,
    'activityLevels': {
      'high': activityLevels['high']!.length,
      'medium': activityLevels['medium']!.length,
      'low': activityLevels['low']!.length,
    },
    'feeStatistics': {
      'totalOutstandingFees': totalFees,
      'averageFeePerMember': isEmpty ? 0.0 : totalFees / length,
      'membersWithFees': where((m) => m is StudentMember && m.calculateFees() > 0).length,
    },
    'borrowingStatistics': {
      'totalBorrowedItems': totalBorrowedItems,
      'averageItemsPerMember': isEmpty ? 0.0 : totalBorrowedItems / length,
    },
  };
}
}
