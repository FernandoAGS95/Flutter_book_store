part of 'book_bloc.dart';

enum BookStatus { initial, loading, success, failure }

class BookState  {
  final BookStatus status;
  final List<Book> books;
  final List<Book> cart; 
  final String? errorMessage;
  final bool isCheckingOut;
  const BookState({
    this.status = BookStatus.initial,
    this.cart = const [], 
    this.books = const [],
    this.errorMessage,
    this.isCheckingOut = false, 
  });

  BookState copyWith({
    BookStatus? status,
    List<Book>? cart,
    List<Book>? books,
    String? errorMessage,
    bool? isCheckingOut,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut
    );
  }

  @override
  List<Object?> get props => [status, books,cart, errorMessage,isCheckingOut];
}
