import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final double rating;
  final int pages;
  final String language;
  final double price;
   final bool isBookMarked;
  final int quantity;
  final bool isComprado; 
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.pages,
    required this.language,
    required this.price,
    this.isBookMarked = false,
    required this.quantity,
    this.isComprado = false
  });

  
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    String? description,
    double? rating,
    int? pages,
    String? language,
    double? price,
    bool? isBookMarked,
    int? quantity,
    bool? isComprado
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      pages: pages ?? this.pages,
      language: language ?? this.language,
      price: price ?? this.price,
      isBookMarked: isBookMarked ?? this.isBookMarked,
      quantity: quantity ?? this.quantity,
      isComprado :isComprado ?? this.isComprado
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        imageUrl,
        description,
        rating,
        pages,
        language,
        price,
        isBookMarked,
        quantity,
        isComprado
      ];
}
