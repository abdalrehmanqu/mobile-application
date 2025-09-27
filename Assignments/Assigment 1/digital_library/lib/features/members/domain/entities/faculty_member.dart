import '../../../borrowing/domain/entities/borrowed_item.dart';
import '../../../library_items/domain/entities/library_item.dart';
import 'member.dart';

class FacultyMember extends Member {
  String department;

  FacultyMember({
    required String memberId,
    required String name,
    required String email,
    required DateTime joinDate,
    required List borrowedItems,
    required this.department,
  }) : super(
         memberId: memberId,
         name: name,
         email: email,
         joinDate: joinDate,
         borrowedItems: List<BorrowedItem>.from(borrowedItems),
         maxBorrowLimit: 20,
         borrowPeriod: 60,
       );
  @override
  String getMemberType() {
    return 'Faculty';
  }

  @override
  bool canBorrowItem(LibraryItem item) {
    if (!super.canBorrowItem(item)) {
      return false;
    }
    return true;
  }
}
