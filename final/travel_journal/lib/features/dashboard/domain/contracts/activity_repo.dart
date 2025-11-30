import '../entities/activity.dart';

abstract class ActivityRepository {
  Stream<List<Activity>> getActivities();
  Future<Activity?> getActivityById(int id);
  Future<void> addActivity(Activity activity);
  Future<void> updateActivity(Activity activity);
  Future<void> deleteActivity(Activity activity);
  Future<List<Activity?>> getActivitiesByTrip(int tripId);
}
