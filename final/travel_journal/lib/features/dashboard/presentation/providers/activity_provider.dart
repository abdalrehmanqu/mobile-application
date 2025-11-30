import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/contracts/activity_repo.dart';
import '../../domain/entities/activity.dart';
import 'repo_providers.dart';

class ActivitytemsState {
  final List<Activity> items;

  ActivitytemsState({required this.items});

  ActivitytemsState copyWith({List<Activity>? items}) {
    return ActivitytemsState(items: items ?? this.items);
  }
}

class ActivityNotifier extends AsyncNotifier<ActivitytemsState> {
  late final ActivityRepository _activityRepo;
  StreamSubscription<List<Activity>>? _subscription;

  @override
  Future<ActivitytemsState> build() async {
    // Get the repository from the provider
    _activityRepo = await ref.read(activityRepoProvider.future);

    // Subscribe to library items stream for reactive updates
    _subscription = _activityRepo.getActivities().listen((items) {
      state = AsyncValue.data(ActivitytemsState(items: items));
    });

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Return initial empty state
    return ActivitytemsState(items: []);
  }

  Future<List<Activity?>> getActivitiesByTrip(int tripId) async {
    try {
      return await _activityRepo.getActivitiesByTrip(tripId);
    } catch (e) {
      return [];
    }
  }

  Future<Activity?> getActivityById(int id) async {
    try {
      return await _activityRepo.getActivityById(id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addActivity(Activity activity) async {
    try {
      await _activityRepo.addActivity(activity);
    } catch (e) {
      return;
    }
  }

  Future<void> updateActivity(Activity activity) async {
    try {
      await _activityRepo.updateActivity(activity);
    } catch (e) {
      return;
    }
  }

  Future<void> deleteActivity(Activity activity) async {
    try {
      await _activityRepo.deleteActivity(activity);
    } catch (e) {
      return;
    }
  }
}

final activityNotifierProvider =
    AsyncNotifierProvider<ActivityNotifier, ActivitytemsState>(
      () => ActivityNotifier(),
    );
