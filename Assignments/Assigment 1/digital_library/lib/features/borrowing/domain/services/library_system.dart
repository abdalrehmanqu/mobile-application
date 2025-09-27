import '../../../library_items/domain/contracts/library_repository.dart';
import '../../../library_items/domain/entities/audiobook.dart';
import '../../../library_items/domain/entities/book.dart';
import '../../../library_items/domain/entities/library_item.dart';
import '../../../members/domain/contracts/member_repository.dart';
import '../../../members/domain/entities/student_member.dart';
import '../entities/borrowed_item.dart';

class LibrarySystem {
  final LibraryRepository _libraryRepository;
  final MemberRepository _memberRepository;
  final Map<String, List<String>> _waitlistByItemId = {};

  LibrarySystem(this._libraryRepository, this._memberRepository);

  Future<bool> borrowItem(String memberId, String itemId) async {
    final member = await _memberRepository.getMember(memberId);
    if (member == null) return false;

    final item = await _libraryRepository.getItem(itemId);
    if (item == null || !item.isAvailable) return false;

    if (!member.canBorrowItem(item)) return false;

    member.borrowedItems.add(
      BorrowedItem(
        borrowDate: DateTime.now(),
        dueDate: DateTime.now().add(Duration(days: 14)),
        item: item,
      ),
    );

    item.isAvailable = false;

    return true;
  }

  Future<bool> returnItem(String memberId, String itemId) async {
    final member = await _memberRepository.getMember(memberId);
    if (member == null) return false;

    BorrowedItem? borrowedItem;
    try {
      borrowedItem = member.borrowedItems.firstWhere(
        (b) => b.item.id == itemId && !b.isReturned,
      );
    } catch (e) {
      return false;
    }

    double fee = member is StudentMember ? member.calculateFees() : 0.0;

    fee > 0 ? (member as StudentMember).payFees(fee) : null;

    borrowedItem.processReturn();
    borrowedItem.item.isAvailable = true;

    return true;
  }

  Future<List<String>> generateOverdueReport() async {
    final List<String> overdueReports = [];

    final allMembers = await _memberRepository.getAllMembers();

    for (final member in allMembers) {
      for (final borrowedItem in member.borrowedItems) {
        if (!borrowedItem.isReturned && borrowedItem.overdue()) {
          overdueReports.add(
            'Member: ${member.name} / ${member.memberId}, Item: ${borrowedItem.item.title}, Overdue Days: ${borrowedItem.getDaysOverdue()}, Fine: \$${member is StudentMember ? member.calculateFees() : 0.0}',
          );
        }
      }
    }

    return overdueReports;
  }

  Future<List<LibraryItem>> recommendItems(
    String memberId,
    int maxRecommendations,
  ) async {
    if (maxRecommendations <= 0) return const [];
    final member = await _memberRepository.getMember(memberId);

    final history = member?.getBorrowingHistory() ?? [];
    final alreadyBorrowedIds = history.map((b) => b.item.id).toSet();

    final favAuthorIds = history
        .expand((b) => b.item.authors.map((a) => a.id))
        .toSet();
    final favCategories = history
        .map((b) => b.item.category.toLowerCase())
        .toSet();

    final allItems = await _libraryRepository.getAllItems();
    final pool = allItems
        .where((i) => i.isAvailable && !alreadyBorrowedIds.contains(i.id))
        .toList();
    if (pool.isEmpty) return const [];

    double score(LibraryItem i) {
      final rating = i is Book
          ? i.getAverageRating() / 5.0
          : (i as Audiobook).getAverageRating() / 5.0;
      final sharedAuthor = i.authors.any((a) => favAuthorIds.contains(a.id))
          ? 1.0
          : 0.0;
      final sameCat = favCategories.contains(i.category.toLowerCase())
          ? 1.0
          : 0.0;
      return 0.7 * rating + 0.2 * sharedAuthor + 0.1 * sameCat;
    }

    pool.sort((a, b) => score(b).compareTo(score(a)));
    return pool.take(maxRecommendations).toList();
  }

  Future<Map<String, dynamic>> processMonthlyReport() async {
    final now = DateTime.now();
    final DateTime startLast, endLast;
    if (now.month == 1) {
      startLast = DateTime(now.year - 1, 12, 1);
      endLast = DateTime(now.year, 1, 1);
    } else {
      startLast = DateTime(now.year, now.month - 1, 1);
      endLast = DateTime(now.year, now.month, 1);
    }

    final DateTime prevStart = (startLast.month == 1)
        ? DateTime(startLast.year - 1, 12, 1)
        : DateTime(startLast.year, startLast.month - 1, 1);
    final DateTime prevEnd = startLast;

    bool inRange(DateTime d, DateTime s, DateTime e) =>
        !d.isBefore(s) && d.isBefore(e);

    double avgRating(LibraryItem item) {
      return item is Book
          ? item.getAverageRating()
          : (item is Audiobook ? item.getAverageRating() : 0.0);
    }

    int reviewCount(LibraryItem item) {
      return item is Book
          ? item.getReviewCount()
          : (item is Audiobook ? item.getReviewCount() : 0);
    }

    double pctDelta(int prev, int curr) =>
        prev == 0 ? (curr == 0 ? 0.0 : 100.0) : ((curr - prev) / prev) * 100.0;

    final members = await _memberRepository.getAllMembers();
    final items = await _libraryRepository.getAllItems();
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

  Future<ReservationResult> handleReservation(
    String memberId,
    String itemId,
  ) async {
    final members = await _memberRepository.getAllMembers();
    final items = await _libraryRepository.getAllItems();

    final member = members.firstWhere(
      (m) => m.memberId == memberId,
      orElse: () => throw StateError('Member not found'),
    );
    final item = items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw StateError('Item not found'),
    );

    if (item.isAvailable)
      return const ReservationResult(queued: false, position: 0);
    if (member.getBorrowingHistory().any(
      (b) => !b.isReturned && b.item.id == itemId,
    )) {
      return const ReservationResult(queued: false, position: 0);
    }

    final q = _waitlistByItemId.putIfAbsent(itemId, () => <String>[]);
    final idx = q.indexOf(memberId);
    if (idx >= 0) return ReservationResult(queued: true, position: idx + 1);

    q.add(memberId);
    return ReservationResult(queued: true, position: q.length);
  }

  String? popNextReservation(String itemId) {
    final q = _waitlistByItemId[itemId];
    if (q == null || q.isEmpty) return null;
    return q.removeAt(0);
  }

  List<String> getReservationQueue(String itemId) =>
      List.unmodifiable(_waitlistByItemId[itemId] ?? const <String>[]);

  bool cancelReservation(String memberId, String itemId) {
    final q = _waitlistByItemId[itemId];
    if (q == null) return false;
    final ok = q.remove(memberId);
    if (q.isEmpty) _waitlistByItemId.remove(itemId);
    return ok;
  }
}

class ReservationResult {
  final bool queued;
  final int position;
  const ReservationResult({required this.queued, required this.position});
}
