import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/supabase/supabase_provider.dart';
import '../../data/repository/trip_repo_supabase.dart';
import '../../data/repository/activity_repo_supabase.dart';
import '../../domain/contracts/trip_repo.dart';
import '../../domain/contracts/activity_repo.dart';

final tripRepoProvider = FutureProvider<TripRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TripRepoSupabase(client);
});

final activityRepoProvider = FutureProvider<ActivityRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ActivityRepoSupabase(client);
});
