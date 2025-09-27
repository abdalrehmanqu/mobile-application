import '../../../library_items/domain/entities/library_item.dart';

class BorrowedItem {
  LibraryItem item;
  DateTime borrowDate;
  DateTime dueDate;
  DateTime? returnDate;
  bool isReturned;

  BorrowedItem({
    required this.item,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.isReturned = false,
  });

  bool overdue() {
    if (isReturned) {
      return false;
    }
    final now = DateTime.now();
    return now.isAfter(dueDate);
  }

  int getDaysOverdue(){
    if (!overdue()) {
      return 0;
    }
    final now = DateTime.now();
    return now.difference(dueDate).inDays;
  }

  double calculateFine(double dailyFineRate) {
    if (!overdue()) {
      return 0.0;
    }
    return getDaysOverdue() * dailyFineRate;
  }

  void extendDueDate(int extraDays) {
    dueDate = dueDate.add(Duration(days: extraDays));
  }

  void processReturn() {
    isReturned = true;
    returnDate = DateTime.now();
  }
}
