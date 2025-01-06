import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';
import 'package:prueba_flutter_2/pages/detail_book.dart';

class BookBookmarkedPage extends StatelessWidget {
  const BookBookmarkedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Books'),
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state.status == BookStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == BookStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else {
            final bookmarkedBooks = state.books.where((book) => book.isBookMarked).toList();

            return ListView.builder(
              itemCount: bookmarkedBooks.length,
              itemBuilder: (context, index) {
                final book = bookmarkedBooks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
       
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(book: book),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.network(
                          book.imageUrl,
                          width: 80,  
                          height: 120, 
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 20), 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              book.author,
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            book.isBookMarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            size: 30,  
                          ),
                          onPressed: () {
                       
                            context.read<BookBloc>().add(
                              ToggleBookmarkEvent(book.id, book.isBookMarked),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
