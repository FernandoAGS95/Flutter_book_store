part of 'book_bloc.dart';

abstract class BookEvent {
  const BookEvent();

  @override
  List<Object?> get props => [];
}
class LoadCartEvent extends BookEvent {}
class LoadBooksEvent extends BookEvent {}
class LoadBookmarkedBooksEvent extends BookEvent {}
class RemoveFromCartEvent extends BookEvent {
  final Book book;

  RemoveFromCartEvent({required this.book});
}

class UpdateQuantityEvent extends BookEvent {
  final Book book;
  final bool increment;

  UpdateQuantityEvent({required this.book, required this.increment});
}
class UpdateBookMarkedStatusEvent extends BookEvent {
  final String bookId;
  final bool isBookMarked;

  UpdateBookMarkedStatusEvent(this.bookId, this.isBookMarked);
}
class ToggleBookmarkEvent extends BookEvent {
  final String bookId;
  final bool currentBookmarkStatus;

  ToggleBookmarkEvent(this.bookId, this.currentBookmarkStatus);
}
class AddBookEvent extends BookEvent {
  final Book newBook;

  AddBookEvent(this.newBook);
}


class AddToCartEvent extends BookEvent {
  final Book book;
  final int quantity;

  const AddToCartEvent(this.book, this.quantity);

  @override
  List<Object> get props => [book];
}
class CheckoutCartEvent extends BookEvent {
  final List<Book> booksToCheckout; 
  CheckoutCartEvent({required this.booksToCheckout});
}
