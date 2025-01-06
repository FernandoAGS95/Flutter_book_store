import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    context.read<BookBloc>().add(LoadCartEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tu carrito"),
      ),
      body: BlocBuilder<BookBloc, BookState>(builder: (context, state) {
        if (state.status == BookStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == BookStatus.success) {
          final cart = state.cart;
          if (cart.isEmpty) {
            return Center(child: Text("El carrito esta vacio"));
          }

          return ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final book = cart[index];
              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        context.read<BookBloc>().add(RemoveFromCartEvent(book: book));
                      },
                    ),
                    Image.network(book.imageUrl),
                  ],
                ),
                title: Text(book.title),
                subtitle: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        context.read<BookBloc>().add(UpdateQuantityEvent(book: book, increment: false));
                      },
                    ),
                    Text("Quantity: ${book.quantity}"),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        context.read<BookBloc>().add(UpdateQuantityEvent(book: book, increment: true));
                      },
                    ),
                  ],
                ),
                trailing: Text("\$${book.price * book.quantity}"),
              );
            },
          );
        } else if (state.status == BookStatus.failure) {
          return Center(child: Text('Error al cargar el carro'));
        } else {
          return Center(child: Text('No tienes items en tu carro'));
        }
      }),
      bottomNavigationBar: BlocBuilder<BookBloc, BookState>(builder: (context, state) {
        double totalAmount = state.cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: \$${totalAmount.toStringAsFixed(2)}"),
              ElevatedButton(
                onPressed: () async {
             
                  context.read<BookBloc>().add(CheckoutCartEvent(booksToCheckout: []));

                 
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Libros comprados"),
                        content: Text("Tus libros han sido comprados con éxito."),
                        actions: [
                          TextButton(
                            onPressed: () {
                           
                              Navigator.pop(context);
                     
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Checkout"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
