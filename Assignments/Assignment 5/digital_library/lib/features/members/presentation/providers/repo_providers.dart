import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/supabase/supabase_client_provider.dart';
import '../../data/repositories/member_repository_supabase.dart';
import '../../domain/contracts/member_repository.dart';

/// Member Repository Provider
/// Provides access to the members repository
/// Uses FutureProvider to support async initialization (for future database integration)
final memberRepoProvider = FutureProvider<MemberRepository>((ref) async {
  final client = ref.read(supabaseClientProvider);
  return MemberRepositorySupabase(client);
});
