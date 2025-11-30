import '../entities/trip.dart';

abstract class TripRepository {
  Stream<List<Trip>> getTrips();
  Future<Trip?> getTripById(int id);
  Future<void> addTrip(Trip trip);
  Future<void> updateTrip(Trip trip);
  Future<void> deleteTrip(Trip trip);
}
