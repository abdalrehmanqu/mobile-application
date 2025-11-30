import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/contracts/trip_repo.dart';
import '../../domain/entities/trip.dart';
import 'repo_providers.dart';

class TripsItemsState {
  final List<Trip> items;

  TripsItemsState({required this.items});

  TripsItemsState copyWith({List<Trip>? items}) {
    return TripsItemsState(items: items ?? this.items);
  }
}

class TripNotifier extends AsyncNotifier<TripsItemsState> {
  late final TripRepository _tripRepo;
  StreamSubscription<List<Trip>>? _subscription;

  @override
  Future<TripsItemsState> build() async {
    // Get the repository from the provider
    _tripRepo = await ref.read(tripRepoProvider.future);

    // Subscribe to library items stream for reactive updates
    _subscription = _tripRepo.getTrips().listen((items) {
      state = AsyncValue.data(TripsItemsState(items: items));
    });

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Return initial empty state
    return TripsItemsState(items: []);
  }

  Future<Trip?> getTripById(int id) async {
    try {
      return await _tripRepo.getTripById(id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addTrip(Trip trip) async {
    try {
      await _tripRepo.addTrip(trip);
    } catch (e) {
      return;
    }
  }

  Future<void> updateTrip(Trip trip) async {
    try {
      await _tripRepo.updateTrip(trip);
    } catch (e) {
      return;
    }
  }

  Future<void> deleteTrip(Trip trip) async {
    try {
      await _tripRepo.deleteTrip(trip);
    } catch (e) {
      return;
    }
  }
}

final tripsProvider = AsyncNotifierProvider<TripNotifier, TripsItemsState>(
  () => TripNotifier(),
);
