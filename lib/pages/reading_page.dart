import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';

class ReadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Libros Leídos"),
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state.status == BookStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == BookStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Error desconocido'));
          }

      
          final readBooks = state.books.where((book) => book.isComprado).toList();

          if (readBooks.isEmpty) {
            return Center(child: Text("No tienes libros leídos"));
          }

          return ListView.builder(
            itemCount: readBooks.length,
            itemBuilder: (context, index) {
              final book = readBooks[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
              
                    Image.network(
                      book.imageUrl,  
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),  
              
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text("Por: ${book.author}", style: TextStyle(color: Colors.grey)),
                          Row(
                            children: List.generate(4, (index) {
                              return Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    
                    TextButton(
                      onPressed: () {
                  
                      },
                      child: Text("Leer"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
