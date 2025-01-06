import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';
import 'package:prueba_flutter_2/pages/carrito_page.dart';
import 'package:prueba_flutter_2/pages/crea_book_page.dart';


class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateBookPage(),
            ),
          );
        },
      ),
      actions: [

        BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
  
            final int cartCount = state.cart.length;

            return Stack(
              clipBehavior: Clip.none, 
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_rounded, color: Colors.black),
                  onPressed: () {
     
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  },
                ),
                if (cartCount > 0) ...[
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            );
          },
        ),

 
       const CircleAvatar(
          backgroundColor: Colors.transparent, 
          backgroundImage: NetworkImage(
            'https://fastly.picsum.photos/id/635/200/300.jpg?hmac=qG6LgnhiwwsL9zn9xA9KffocQAHkej2ueth9FHJl2pc',
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
