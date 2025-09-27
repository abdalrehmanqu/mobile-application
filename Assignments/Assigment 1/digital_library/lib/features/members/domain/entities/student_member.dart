import '../../../borrowing/domain/entities/borrowed_item.dart';
import '../../../library_items/domain/entities/library_item.dart';
import '../contracts/payable.dart';
import 'member.dart';


class StudentMember extends Member implements Payable {
  final String studentId;

  StudentMember({
    required String memberId,
    required String name,
    required String email,
    required DateTime joinDate,
    required List borrowedItems,
    required this.studentId,
  }) : super(
          memberId: memberId,
          name: name,
          email: email,
          joinDate: joinDate,
          borrowedItems: List<BorrowedItem>.from(borrowedItems),
          maxBorrowLimit: 5,
          borrowPeriod: 14,
        );
        
  @override
  String getMemberType() {
    return 'Student';
  }
  @override
  bool canBorrowItem(LibraryItem item){
    if(!super.canBorrowItem(item)){
      return false;
    }
    if(super.getOverdueItems().isNotEmpty){
      return false;
    }
    return true;
  }
  
  @override
  double calculateFees() {
    double totalFine = 0.0;
    for (var borrowedItem in borrowedItems) {
      var fine = borrowedItem.calculateFine(2.0);
      totalFine += fine > 50.0 ? 50.0 : fine;
    }
    return totalFine;
  }
  
  @override
  bool payFees(double amount) {
    double totalFees = calculateFees();
    if (amount >= totalFees) {
      return true;
    }
    return false;
  }
}
