import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/supabase/supabase_client_provider.dart';
import '../../data/repositories/transaction_repository_supabase.dart';
import '../../domain/contracts/transaction_repository.dart';

/// Transaction Repository Provider
/// Provides access to the transaction repository
/// Uses FutureProvider to support async initialization (for future database integration)
final transactionRepoProvider = FutureProvider<TransactionRepository>((ref) async {
  final client = ref.read(supabaseClientProvider);
  return TransactionRepositorySupabase(client);
});
