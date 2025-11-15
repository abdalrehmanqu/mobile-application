import 'package:digital_library/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/contracts/transaction_repository.dart';

/// Transaction Repository Provider
/// Provides access to the transaction repository
/// Uses FutureProvider to support async initialization (for future database integration)
final transactionRepoProvider = FutureProvider<TransactionRepository>((ref) async {
  final db=await ref.watch(databaseProvider.future);
  return TransactionRepositoryImpl(db.transactionDao);
});
