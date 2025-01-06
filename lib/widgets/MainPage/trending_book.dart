import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';
import 'package:prueba_flutter_2/pages/detail_book.dart';
import 'package:prueba_flutter_2/pages/more_books.dart';

class TrendingBooksSection extends StatelessWidget {
  const TrendingBooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state.status == BookStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == BookStatus.success) {
          final trendingBooks = state.books;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trending Books',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreBooksPage(),
                          ),
                        );
                      },
                      child: const Text('See More'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 250, 
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingBooks.length,
                    itemBuilder: (context, index) {
                      final book = trendingBooks[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailPage(book: book),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0), 
                                child: Container(
                                  width: 140,
                                  height: 180, 
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Image.network(
                                    book.imageUrl,
                                    width: 140,
                                    height: 180, 
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                book.author,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.title,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state.status == BookStatus.failure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else {
          return const Center(child: Text('Failed to load books.'));
        }
      },
    );
  }
}
