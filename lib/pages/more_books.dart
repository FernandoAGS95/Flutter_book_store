import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';
import 'package:prueba_flutter_2/models/book.dart';
import 'package:prueba_flutter_2/pages/detail_book.dart';

class MoreBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<BookBloc>().add(LoadBooksEvent());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("More Books"),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
          
            },
          ),
        ],
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state.status == BookStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == BookStatus.success) {
            final books = state.books;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView( 
                child: GridView.builder(
                  shrinkWrap: true, 
                  physics:const  NeverScrollableScrollPhysics(), 
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0, 
                    mainAxisSpacing: 10.0, 
                    childAspectRatio: 0.65, 
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailPage(book: book),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: AspectRatio(
                              aspectRatio: 1, 
                              child: Image.network(
                                book.imageUrl,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 2), 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.author,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  book.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16, 
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(   height: 16), 
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state.status == BookStatus.failure) {
            return const  Center(child: Text('Failed to load books.'));
          } else {
            return const Center(child: Text('No books available.'));
          }
        },
      ),
    );
  }
}
