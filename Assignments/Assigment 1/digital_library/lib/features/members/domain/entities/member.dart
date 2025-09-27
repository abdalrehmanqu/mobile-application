import '../../../borrowing/domain/entities/borrowed_item.dart';
import '../../../library_items/domain/entities/library_item.dart';

abstract class Member {
  final String memberId;
  final String name;
  String email;
  DateTime joinDate;
  List<BorrowedItem> borrowedItems;
  int maxBorrowLimit;
  int borrowPeriod;
  String? profileImageUrl;

  Member({
    required this.memberId,
    required this.name,
    required this.email,
    required this.joinDate,
    required this.borrowedItems,
    required this.maxBorrowLimit,
    required this.borrowPeriod,
    this.profileImageUrl,
  });

  bool canBorrowItem(LibraryItem item) {
    if (borrowedItems.length >= maxBorrowLimit) {
      return false;
    }
    if (item.isAvailable == false) {
      return false;
    }
    return true;
  }

  List<BorrowedItem> getBorrowingHistory() {
    return borrowedItems;
  }

  List<BorrowedItem> getOverdueItems() {
    return borrowedItems.where((item) => item.overdue()).toList();
  }

  Map<String, dynamic> getMembershipSummary() {
    return {
      'Member ID': memberId,
      'Name': name,
      'Email': email,
      'Join Date': joinDate.toIso8601String(),
      'Current Borrowed Items': borrowedItems.length,
      'Max Borrow Limit': maxBorrowLimit,
      'Borrow Period (days)': borrowPeriod,
    };
  }

  String getMemberType();
}
