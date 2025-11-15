import 'package:digital_library/core/database/database_provider.dart';
import 'package:digital_library/core/database/database_seeder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';

void main() async{
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
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Digital Library',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
    );
  }
}
