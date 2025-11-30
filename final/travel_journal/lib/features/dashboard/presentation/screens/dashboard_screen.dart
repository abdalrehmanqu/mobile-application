import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/trip_provider.dart';
import '../widgets/trip_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Journal'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: tripsAsync.when(
        data: (state) {
          final trips = state.items;
          if (trips == []) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flight_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No trips yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add a new trip',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return TripCard(
                  trip: trip,
                  onTap: () {
                    context.push(
                      '/trip/${trip.id}/activities?tripName=${Uri.encodeComponent(trip.name)}',
                    );
                  },
                  onEdit: () {
                    context.push('/edit-trip/${trip.id}');
                  },
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Trip'),
                        content: Text(
                          'Are you sure you want to delete "${trip.name}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final notifier = ref.read(
                        tripsProvider.notifier,
                      );
                      await notifier.deleteTrip(trip);
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () => ref.invalidate(tripNotifierProvider),
              //   child: const Text('Retry'),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-trip'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
