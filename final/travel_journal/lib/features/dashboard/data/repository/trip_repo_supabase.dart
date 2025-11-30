import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/trip_repo.dart';
import '../../domain/entities/trip.dart';

class TripRepoSupabase implements TripRepository {
  final SupabaseClient client;

  TripRepoSupabase(this.client);

  @override
  Stream<List<Trip>> getTrips() {
    return client
        .from('trips')
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map((row) => Trip.fromJson(row)).toList());
  }

  @override
  Future<Trip?> getTripById(int id) async {
    final data = await client.from('trips').select().eq('id', id).maybeSingle();
    if (data == null) throw Exception('Book with ID $id not found');
    return Trip.fromJson(data);
  }

  @override
  Future<void> addTrip(Trip trip) async {
    await client.from('trip').insert(trip.toJson());
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    await client.from('trips').update(trip.toJson()).eq('id', trip.id!);
  }

  @override
  Future<void> deleteTrip(Trip trip) async {
    await client.from('trips').delete().eq('id', trip.id!);
  }
}
