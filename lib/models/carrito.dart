import 'package:equatable/equatable.dart';
import 'book.dart';

class Cart extends Equatable {
  final String id;
  final List<Book> books;
  final int cantidad;

  const Cart({
    required this.id,
    required this.books,
    required this.cantidad,
  });


  Cart copyWith({
    String? id,
    List<Book>? books,
    int? cantidad,
  }) {
    return Cart(
      id: id ?? this.id,
      books: books ?? this.books,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  @override
  List<Object?> get props => [id, books,cantidad];
}
