import 'package:flutter/material.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/entities/audiobook.dart';
import '../../domain/entities/book.dart';

class LibraryItemDetailsScreen extends StatelessWidget {
  final String itemId;

  const LibraryItemDetailsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final item = DataService().getItem(itemId);

    if (item == null) {
      return const Scaffold(body: Center(child: Text('Item not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal.shade800,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // header card
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(item.getItemType() == 'book' ? Icons.book : Icons.headphones, size: 50, color: Colors.teal.shade600),
                        const SizedBox(height: 25),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          item.getItemType(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: item.isAvailable
                                ? Colors.teal.shade600
                                : Colors.red.shade800,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            item.isAvailable ? 'Available' : 'Unavailable',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // information card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.001),
                        1: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text('Category'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text(item.category),
                            ),
                          ],
                        ),
                        
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text('Published Year'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text(item.publishedYear.toString()),
                            ),
                          ],
                        ),
                        if (item is Book) ...[
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text('ISBN'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text(item.isbn),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text('Pages'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text(item.pageCount.toString()),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text('Publisher'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text(item.publisher),
                              ),
                            ],
                          ),
                        ],
                        if (item is AudioBook) ...[
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text('Duration'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text('${item.duration} hours'),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text('Narrator'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text(item.narrator),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text('File Size'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text('${item.fileSize} MB'),
                              ),
                            ],
                          ),
                        ],

                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // authors card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Authors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: item.authors.map((author) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.lightBlue.shade100,
                                child: Icon(Icons.person, color: Colors.blue.shade800, size: 16,),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(author.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                  const SizedBox(height: 3),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      author.biography ?? 'No biography available.',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color.fromARGB(190, 0, 0, 0),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // description card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Text(
                      item.description ?? 'No description available.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // reviews card
            Card(
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber.shade600),
                        const SizedBox(width: 5),
                        Text(
                          item.getAverageRating().toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('(${item.getReviewCount()} reviews)'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (item.reviews.isEmpty)
                      const Text('No reviews available.')
                    else
                      Column(
                        children: item.reviews.map((review) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, size: 16, color: Colors.blue.shade800),
                                    const SizedBox(width: 5),
                                    Text(
                                      review.reviewerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < review.rating ? Icons.star : Icons.star_border,
                                          size: 14,
                                          color: Colors.amber.shade600,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(review.comment),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
