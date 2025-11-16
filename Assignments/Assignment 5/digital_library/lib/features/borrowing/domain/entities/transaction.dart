// TODO: Add Floor annotations when implementing database
// @entity
class Transaction {
  // @primaryKey
  final String id;

  final String memberId;
  final String bookId;
  final DateTime borrowDate;
  DateTime dueDate;
  DateTime? returnDate;
  bool isReturned;

  Transaction({
    required this.id,
    required this.memberId,
    required this.bookId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.isReturned = false,
  });

  /// Checks if past due date and not returned
  bool isOverdue() {
    if (isReturned) return false;
    return DateTime.now().isAfter(dueDate);
  }

  /// Calculates overdue days, returns 0 if not overdue
  int getDaysOverdue() {
    if (!isOverdue()) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  /// Computes fee based on overdue days
  /// QR 2 per day late fee
  double calculateLateFee() {
    final daysOverdue = getDaysOverdue();
    return daysOverdue * 2.0;
  }

  /// Extends due date if allowed
  void extendDueDate(int additionalDays) {
    if (isReturned) {
      throw StateError('Cannot extend due date for returned item');
    }
    dueDate = dueDate.add(Duration(days: additionalDays));
  }

  /// Marks as returned with current timestamp
  void processReturn() {
    if (isReturned) {
      throw StateError('Item already returned');
    }
    returnDate = DateTime.now();
    isReturned = true;
  }

  /// Creates a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    String readString(List<String> keys, String fieldName) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        return value.toString();
      }
      throw FormatException('Missing "$fieldName" in transaction JSON data.');
    }

    DateTime readDate(List<String> keys, String fieldName) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        if (value is DateTime) return value;
        if (value is String) {
          final parsed = DateTime.tryParse(value);
          if (parsed != null) return parsed;
        }
      }
      throw FormatException('Missing "$fieldName" in transaction JSON data.');
    }

    DateTime? readOptionalDate(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value == null) continue;
        if (value is DateTime) return value;
        if (value is String) {
          final parsed = DateTime.tryParse(value);
          if (parsed != null) return parsed;
        }
      }
      return null;
    }

    bool readBool(List<String> keys, {bool defaultValue = false}) {
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

    return Transaction(
      id: readString(['id', 'transaction_id'], 'id'),
      memberId: readString(['memberId', 'member_id'], 'memberId'),
      bookId: readString(['bookId', 'book_id'], 'bookId'),
      borrowDate: readDate(['borrowDate', 'borrow_date'], 'borrowDate'),
      dueDate: readDate(['dueDate', 'due_date'], 'dueDate'),
      returnDate: readOptionalDate(['returnDate', 'return_date']),
      isReturned: readBool(['isReturned', 'is_returned', 'returned']),
    );
  }

  /// Converts Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'book_id': bookId,
      'borrow_date': borrowDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'return_date': returnDate?.toIso8601String(),
      'is_returned': isReturned,
    };
  }

  @override
  String toString() {
    return 'Transaction(id: $id, memberId: $memberId, bookId: $bookId, borrowDate: $borrowDate, dueDate: $dueDate, isReturned: $isReturned, overdue: ${isOverdue()})';
  }
}
