import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:prueba_flutter_2/models/book.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final Dio dio;

  BookBloc({required this.dio}) : super(const BookState()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
    on<LoadBookmarkedBooksEvent>(_onLoadBookmarkedBooks);
    on<AddBookEvent>(_onAddBook);
    on<AddToCartEvent>(_onAddToCartEvent); 
    on<LoadCartEvent>(_onLoadCartEvent);
    on<RemoveFromCartEvent>(_onRemoveFromCartEvent);
    on<UpdateQuantityEvent>(_onUpdateQuantityEvent);
    on<CheckoutCartEvent>(_onCheckoutCartEvent);
  }
void _onRemoveFromCartEvent(RemoveFromCartEvent event, Emitter<BookState> emit) async {
  try {
    final updatedCart = List<Book>.from(state.cart)..removeWhere((book) => book.id == event.book.id);
    await dio.delete("https://api-vdm5rvlgia-uc.a.run.app/cart/${event.book.id}");
    emit(state.copyWith(cart: updatedCart));
  } catch (e) {
    emit(state.copyWith(errorMessage: 'Error al eliminar del carrito.'));
  }
}

void _onUpdateQuantityEvent(UpdateQuantityEvent event, Emitter<BookState> emit) async {
  try {
    final updatedCart = state.cart.map((book) {
      if (book.id == event.book.id) {
        final newQuantity = event.increment
            ? book.quantity + 1
            : (book.quantity > 1 ? book.quantity - 1 : 1); 
        
        return book.copyWith(quantity: newQuantity);
      }

      return book;
    }).toList();

    final updatedBook = updatedCart.firstWhere((book) => book.id == event.book.id);


    print({"new quantity": updatedBook.quantity});
    print({"event.increment": event.increment});
    await dio.put(
      "https://api-vdm5rvlgia-uc.a.run.app/cart/${updatedBook.id}",
      data: {
        "quantity": updatedBook.quantity,
        "increment":event.increment,
        "fromDetail":false

      },
    );

    emit(state.copyWith(cart: updatedCart));
  } catch (e) {
    emit(state.copyWith(errorMessage: 'Error al actualizar la cantidad del carrito.'));
  }
}





void _onLoadCartEvent(LoadCartEvent event, Emitter<BookState> emit) async {
  try {
    final response = await dio.get("https://api-vdm5rvlgia-uc.a.run.app/cart");
    print(response.data); 
    final cartItems = List<Map<String, dynamic>>.from(response.data);
    final books = cartItems.map((json) {
      return Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        price: json['price'].toDouble(),
        rating: json['rating'].toDouble(),
        pages: json['pages'],
        language: json['language'],
        isBookMarked: json['isBookMarked'],
        quantity: json['quantity'],
      );
    }).toList();

    emit(state.copyWith(cart: books)); 
  } catch (e) {
    emit(state.copyWith(errorMessage: 'No se pudo cargar el carrito.'));
  }
}

void _onAddToCartEvent(AddToCartEvent event, Emitter<BookState> emit) async {
  final currentState = state;

  if (currentState.books.isNotEmpty) {
    final existingBookIndex = currentState.cart.indexWhere((b) => b.id == event.book.id);

    List<Book> updatedCart;

    if (existingBookIndex == -1) {
      final bookToAdd = event.book.copyWith(quantity: event.quantity);
      print({"event quantitu":event.quantity});
      updatedCart = [...currentState.cart, bookToAdd];
      try {
        await dio.post(
          "https://api-vdm5rvlgia-uc.a.run.app/cart",
          data: {
            "id": bookToAdd.id,
            "title": bookToAdd.title,
            "author": bookToAdd.author,
            "description": bookToAdd.description,
            "imageUrl": bookToAdd.imageUrl,
            "price": bookToAdd.price,
            "rating": bookToAdd.rating,
            "pages": bookToAdd.pages,
            "language": bookToAdd.language,
            "isBookMarked": bookToAdd.isBookMarked,
            "quantity": event.quantity,
          },
        );

        emit(state.copyWith(cart: updatedCart));
      } catch (e) {
        emit(state.copyWith(errorMessage: 'Error al agregar al carrito en Firebase.'));
      }
    } else {
      print({"valor quantity 4":currentState.cart[existingBookIndex].quantity});
      print({"valor quantity 66":event.quantity});
      final updatedBook = currentState.cart[existingBookIndex].copyWith(
        quantity: currentState.cart[existingBookIndex].quantity + event.quantity,
      );
    print({"updatedBOok":updatedBook.quantity});
      updatedCart = List<Book>.from(currentState.cart);
      updatedCart[existingBookIndex] = updatedBook;

      print(updatedBook.quantity);
      try {
        await dio.put(
          "https://api-vdm5rvlgia-uc.a.run.app/cart/${updatedBook.id}",
          data: {
            "increment": updatedBook.quantity,
            "quantity":event.quantity,
            "fromDetail":true
          },
        );

        emit(state.copyWith(cart: updatedCart));
      } catch (e) {
        emit(state.copyWith(errorMessage: 'Error al actualizar el carrito en Firebase.'));
      }
    }
  }
}

Future<void> _onAddBook(AddBookEvent event, Emitter<BookState> emit) async {
  emit(state.copyWith(status: BookStatus.loading));

  try {
    final lastId = state.books.isNotEmpty
        ? int.parse(state.books.last.id) 
        : 0;

    final newBookWithId = event.newBook.copyWith(id: (lastId + 1).toString());
    
    final response = await dio.post(
      "https://api-vdm5rvlgia-uc.a.run.app/adl_spotify", 
      data: {
        "id":newBookWithId.id,
        "title": newBookWithId.title,
        "author": newBookWithId.author,
        "description": newBookWithId.description,
        "imageUrl": newBookWithId.imageUrl,
        "price": newBookWithId.price,
        "rating": newBookWithId.rating,
        "pages": newBookWithId.pages,
        "language": newBookWithId.language,
        "isBookMarked": newBookWithId.isBookMarked,
        "quantity":newBookWithId.quantity,
        "isComprado":newBookWithId.isComprado
      },
    );

    if (response.statusCode == 201) {
      final updatedBooks = List<Book>.from(state.books)..add(newBookWithId);

      emit(state.copyWith(status: BookStatus.success, books: updatedBooks));
    } else {
      emit(state.copyWith(status: BookStatus.failure, errorMessage: 'Failed to add book.'));
    }
  } catch (e) {
    emit(state.copyWith(status: BookStatus.failure, errorMessage: e.toString()));
  }
}

void _onLoadBookmarkedBooks(LoadBookmarkedBooksEvent event, Emitter<BookState> emit) async {
  emit(state.copyWith(status: BookStatus.loading));
  try {
    final bookmarkedBooks = state.books.where((book) => book.isBookMarked).toList();
    emit(state.copyWith(status: BookStatus.success, books: bookmarkedBooks));
  } catch (e) {
    emit(state.copyWith(status: BookStatus.failure, errorMessage: e.toString()));
  }
}
Future<void> _onLoadBooks(LoadBooksEvent event, Emitter<BookState> emit) async {
    emit(state.copyWith(status: BookStatus.loading));
    try {
      final response = await dio.get("https://api-vdm5rvlgia-uc.a.run.app/adl_spotify");
      final data = List<Map<String, dynamic>>.from(response.data);
      final books = data.map((json) {
        return Book(
          id: json['id'] ?? json['documentId'] ?? json['key'],
          title: json['title'],
          author: json['author'],
          description: json['description'],
          imageUrl: json['imageUrl'], 
          price: json['price'].toDouble(),
          rating: json['rating'].toDouble(),
          pages: json['pages'],
          language: json['language'],
          isBookMarked: json['isBookMarked'],
          quantity: json['quantity'],
          isComprado: json['isComprado'],

        );
      }).toList();
    
      emit(state.copyWith(status: BookStatus.success, books: books));
    } catch (e) {
      emit(state.copyWith(
        status: BookStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onToggleBookmark(ToggleBookmarkEvent event, Emitter<BookState> emit) async {

  final book = state.books.firstWhere((book) => book.id == event.bookId);
  

  final updatedBook = book.copyWith(isBookMarked: !book.isBookMarked);

 
  print(updatedBook.id);
  try {
    await dio.put(
      "https://api-vdm5rvlgia-uc.a.run.app/adl_spotify/${book.id}",
      data: {
        "isBookMarked": updatedBook.isBookMarked,
        
      },
    );

   
    final updatedBooks = state.books.map((b) {
      if (b.id == event.bookId) {
        return updatedBook;  
      }
      return b;
    }).toList();

    emit(state.copyWith(books: updatedBooks,));
  } catch (e) {
    emit(state.copyWith(status: BookStatus.failure, errorMessage: e.toString()));
  }
  }

void _onCheckoutCartEvent(CheckoutCartEvent event, Emitter<BookState> emit) async {
  try {
    final updatedCart = state.cart.map((book) {
      return book.copyWith(isComprado: true); 
    }).toList();

    for (var book in updatedCart) {
      await dio.put(
        "https://api-vdm5rvlgia-uc.a.run.app/adl_spotify/${book.id}",
        data: {
          "isComprado": true,
        },
      );

      await dio.delete("https://api-vdm5rvlgia-uc.a.run.app/cart/${book.id}");
    }

    final updatedBooks = state.books.map((b) {
      final updatedBook = updatedCart.firstWhere((book) => book.id == b.id, orElse: () => b);
      return updatedBook;
    }).toList();

    emit(state.copyWith(cart: [], books: updatedBooks));

  } catch (e) {
    emit(state.copyWith(errorMessage: 'Error al realizar el checkout.'));
  }
}


}


