import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/edit_trip_screen.dart';
import '../../features/dashboard/presentation/screens/activities_by_trip_screen.dart';
import '../../features/dashboard/presentation/screens/add_activity_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/add-trip',
        builder: (context, state) => const EditTripScreen(),
      ),
      GoRoute(
        path: '/edit-trip/:tripId',
        builder: (context, state) {
          final tripId = int.parse(state.pathParameters['tripId']!);
          return EditTripScreen(tripId: tripId);
        },
      ),
      GoRoute(
        path: '/trip/:tripId/activities',
        builder: (context, state) {
          final tripId = int.parse(state.pathParameters['tripId']!);
          final tripName = state.uri.queryParameters['tripName'] ?? 'Activities';
          return ActivitiesByTripScreen(tripId: tripId, tripName: tripName);
        },
      ),
      GoRoute(
        path: '/trip/:tripId/add-activity',
        builder: (context, state) {
          final tripId = int.parse(state.pathParameters['tripId']!);
          return AddActivityScreen(tripId: tripId);
        },
      ),
    ],
  );
}
