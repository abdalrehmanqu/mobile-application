import 'package:class_manager/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:class_manager/features/dashboard/presentation/screens/students_by_class_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => DashboardScreen()),
      GoRoute(
        path: '/class/:id',
        builder: (context, state) {
          final idParam = state.pathParameters['id'];
          final id = int.tryParse(idParam ?? '');
          if (id==null) return DashboardScreen();
          return StudentsByClassScreen(classId: id);
        },
      ),
    ],
  );
}
