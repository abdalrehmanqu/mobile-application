import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Welcome to digital library", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Manage your library items and members", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 50),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Card(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () => context.go('/libraryItems'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.book, size: 40, color: Colors.teal.shade600),
                          const SizedBox(height: 10),
                          Text('Library Items', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("Browse Books & AudioBooks", style: TextStyle(fontSize: 10, color: Colors.grey.shade600),textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                height: 150,
                child: Card(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () => context.go('/members'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.group, size: 40, color: Colors.deepPurple.shade600),
                          const SizedBox(height: 10),
                          Text('Members', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("View Library Members", style: TextStyle(fontSize: 10, color: Colors.grey.shade600),textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
