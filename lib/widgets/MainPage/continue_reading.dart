import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';
import 'package:prueba_flutter_2/pages/reading_page.dart';

class ContinueReadingSection extends StatelessWidget {
  const ContinueReadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color:  Color(0xFF4B967D), 
        borderRadius:  BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ), 
      ),
      child: BlocBuilder<BookBloc, BookState>(
        builder: (context, state,) {
          if (state.status == BookStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == BookStatus.failure) {
            return const Center(child: Text('Failed to load book.', style: TextStyle(color: Colors.white)));
          } else if (state.books.isEmpty) {
            return const Center(child: Text('No books to continue.', style: TextStyle(color: Colors.white)));
          }

          final book = state.books.firstWhere(
            (book) => book.isComprado && book.quantity > 0,
          );

          if (book == null ) {
            return const Center(child: Text('No book in progress.', style: TextStyle(color: Colors.white)));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.drag_handle,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Continue Reading',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  ReadingPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book.imageUrl,
                          height: 100,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'By ${book.author}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(4, (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: 0.65,
                              strokeWidth: 6,
                              backgroundColor: Colors.grey[300],
                              color: Colors.green,
                            ),
                           const  Center(
                              child: Text(
                                '65%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
