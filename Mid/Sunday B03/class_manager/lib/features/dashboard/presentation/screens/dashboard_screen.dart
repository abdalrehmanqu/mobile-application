import 'package:class_manager/features/dashboard/presentation/providers/class_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Load classes using ref.watch()
    // TODO: Handle loading/error/data states using .when()
    // TODO: Display classes in ListView with cards
    // TODO: Navigate to students screen when class card is tapped
    final classesAsyncValue = ref.watch(classNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Class Manger',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: classesAsyncValue.when(
        data: (classData) {
          final classes = classData.classes;
          return Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final item = classes[index];
                return ListTile(
                  onTap: () {
                    context.push('/class/${item.id}');
                  },
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue),
                  ),

                  leading: Icon(Icons.book, color: Colors.blue),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      item.subject,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book, color: Colors.blue, size: 12),
                          const SizedBox(width: 3),
                          Text(item.subject, textAlign: TextAlign.start),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.blue, size: 12),
                          const SizedBox(width: 3),
                          Text(item.grade, textAlign: TextAlign.start),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        },
        error: (error, stackTrace) => Text("Error: $error"),
        loading: () => CircularProgressIndicator(),
      ),
    );
  }
}
