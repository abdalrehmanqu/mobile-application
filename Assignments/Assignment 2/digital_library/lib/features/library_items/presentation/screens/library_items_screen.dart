import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/entities/library_item.dart';

class LibraryItemsScreen extends StatefulWidget {
  const LibraryItemsScreen({super.key});

  @override
  State<LibraryItemsScreen> createState() => _LibraryItemsScreenState();
}

class _LibraryItemsScreenState extends State<LibraryItemsScreen> {
  final _dataService = DataService();
  List<LibraryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _items = _dataService.getAllItems();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          //searchBar
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search by title or author...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    _items = _dataService.searchItems(query);
                  });
                },
              ),
            ),
          ),
          
          //list of libary items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  onTap: () {
                    context.push('/library-items/${item.id}');
                  },
                  tileColor: Colors.lightBlue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.teal.shade100),
                  ),
                  
                  leading: Icon(
                    item.getItemType() == 'Book' ? Icons.book : Icons.headphones,
                    color: item.isAvailable ? Colors.teal.shade700 : Colors.red.shade700,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(item.title,style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.authors.map((a) => a.name).join(', '),textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            item.isAvailable ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: item.isAvailable ? Colors.teal.shade700 : Colors.red.shade700,
                          ),
                          const SizedBox(width: 5),
                          Text(item.isAvailable ? 'Available' : 'Not Available', style: TextStyle(color: item.isAvailable ? Colors.teal.shade700 : Colors.red.shade700)),
                          const SizedBox(width: 16),
                        ],
                      )
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }
}
