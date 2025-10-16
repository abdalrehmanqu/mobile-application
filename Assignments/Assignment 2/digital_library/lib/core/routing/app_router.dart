import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/borrowing/presentation/screens/home_screen.dart';
import '../../features/library_items/presentation/screens/library_items_screen.dart';
import '../../features/library_items/presentation/screens/library_item_details_screen.dart';
import '../../features/members/presentation/screens/members_screen.dart';
import '../../features/members/presentation/screens/member_details_screen.dart';
import 'shell_scaffold.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'loginPage',
      builder: (context, state) => LoginScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        int currentIndex = 0;
        final location = state.uri.toString();

        if (location.startsWith('/home')) {
          currentIndex = 0;
        } else if (location.startsWith('/libraryItems')) {
          currentIndex = 1;
        } else if (location.startsWith('/members')) {
          currentIndex = 2;
        }

        return ShellScaffold(currentIndex: currentIndex, child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'homePage',
          builder: (context, state) => const HomeScreen(),
        ),

        GoRoute(
          path: '/libraryItems',
          name: 'libraryItemsPage',
          builder: (context, state) => const LibraryItemsScreen(),
        ),

        GoRoute(
          path: '/members',
          name: 'membersPage',
          builder: (context, state) => const MembersScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/library-items/:id',
      name: 'libraryItemDetailsPage',
      builder: (context, state) {
        final itemId = state.pathParameters['id']!;
        return LibraryItemDetailsScreen(itemId: itemId);
      },
    ),
    GoRoute(
      path: '/members/:id',
      name: 'memberDetailsPage',
      builder: (context, state) {
        final memberId = state.pathParameters['id']!;
        return MemberDetailsScreen(memberId: memberId);
      },
    ),
  ],
);
