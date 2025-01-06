import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';
import 'package:prueba_flutter_2/models/book.dart';

class CreateBookPage extends StatefulWidget {
  const CreateBookPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateBookPageState createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Book'),
      ),
      body: BlocListener<BookBloc, BookState>(
        listener: (context, state) {
          if (state.status == BookStatus.success) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Libro Agregado'),
                  content: const Text('El libro se ha agregado correctamente.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/');
                      },
                    ),
                  ],
                );
              },
            );
          }

          if (state.status == BookStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Author'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese un  autor';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _ratingController,
                    decoration: const InputDecoration(labelText: 'Rating'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _pagesController,
                    decoration: const InputDecoration(labelText: 'Pages'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _languageController,
                    decoration: const InputDecoration(labelText: 'Language'),
                  ),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese una URL ';
                      }
                      if (!Uri.tryParse(value)!.hasAbsolutePath ?? false) {
                        return 'Ingrese una ur correcta ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese una cantidad';
                      }
                      final quantity = int.tryParse(value);
                      if (quantity == null || quantity <= 0) {
                        return 'cantidad debeser mayor a 0';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newBook = Book(
                            id: '',
                            title: _titleController.text,
                            author: _authorController.text,
                            description: _descriptionController.text,
                            imageUrl: _imageUrlController.text,
                            price: double.tryParse(_priceController.text) ?? 0.0,
                            rating: double.tryParse(_ratingController.text) ?? 0.0,
                            pages: int.tryParse(_pagesController.text) ?? 0,
                            language: _languageController.text,
                            quantity: int.tryParse(_quantityController.text) ?? 1,
                          );

                          context.read<BookBloc>().add(AddBookEvent(newBook));
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
