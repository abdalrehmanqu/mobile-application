import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/core/data/database/database_provider.dart';
import 'package:class_manager/core/data/database/database_seeder.dart';
import 'package:class_manager/core/navigations/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  try {
    final database = await container.read(databaseProvider.future);
    await DatabaseSeeder.seedDatabase(database);
    debugPrint('Database initialized and seeded successfully');
  } catch (e) {
    debugPrint('Error initializing database: $e');
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Class Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
