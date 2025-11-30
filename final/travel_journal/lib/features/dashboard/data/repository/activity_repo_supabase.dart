import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/activity_repo.dart';
import '../../domain/entities/activity.dart';

class ActivityRepoSupabase implements ActivityRepository {
  final SupabaseClient client;

  ActivityRepoSupabase(this.client);
  //activities
  @override
  Stream<List<Activity>> getActivities() {
    return client
        .from('activites')
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map((row) => Activity.fromJson(row)).toList());
  }

  @override
  Future<Activity?> getActivityById(int id) async {
    final data = await client
        .from('activities')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (data == null) throw Exception('Book with ID $id not found');
    return Activity.fromJson(data);
  }

  @override
  Future<List<Activity?>> getActivitiesByTrip(int tripId) async {
    final data = await client.from('activities').select().eq('trip_id', tripId);
    return data.map<Activity>((row) => Activity.fromJson(row)).toList();
  }

  @override
  Future<void> addActivity(Activity activity) async {
    await client.from('activities').insert(activity.toJson());
  }

  @override
  Future<void> updateActivity(Activity activity) async {
    await client
        .from('activities')
        .update(activity.toJson())
        .eq('id', activity.id!);
  }

  @override
  Future<void> deleteActivity(Activity activity) async {
    await client.from('activities').delete().eq('id', activity.id!);
  }
}
