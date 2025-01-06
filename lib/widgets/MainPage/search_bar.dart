import 'package:flutter/material.dart';

class SearchBarFena extends StatelessWidget {
  const SearchBarFena({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        textAlignVertical: TextAlignVertical.center, 
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 88, 87, 87),),
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey[600]), 
          suffixIcon: const Icon(Icons.mic_sharp, color: Color.fromARGB(255, 88, 87, 87)),
          filled: true, 
          fillColor: Colors.grey[200], 
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), 
        ),
      ),
    );
  }
}
