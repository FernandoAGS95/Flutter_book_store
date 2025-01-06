import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_flutter_2/BLoC/book_bloc.dart';
import 'package:prueba_flutter_2/pages/main_page.dart';

import 'package:dio/dio.dart';

void main() {
  final dio = Dio(); 

  runApp(
    BlocProvider(
      create: (context) => BookBloc(dio: dio)..add(LoadBooksEvent()),
      child: const MaterialApp(
        home: MainPage(),
      ),
    ),
  );
}
