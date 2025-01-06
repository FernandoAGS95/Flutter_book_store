import 'package:flutter/material.dart';
import 'package:prueba_flutter_2/pages/book_bookmarked.dart';
import 'package:prueba_flutter_2/pages/reading_page.dart';


class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0, 
        selectedFontSize: 16, 
        unselectedFontSize: 14, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Reading',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
           
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookBookmarkedPage()),
            );
          }else if (index == 1) {
       
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ReadingPage()),
            );
          }
        },
      ),
    );
  }
}
