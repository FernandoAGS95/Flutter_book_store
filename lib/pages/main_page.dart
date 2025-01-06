import 'package:flutter/material.dart';
import 'package:prueba_flutter_2/widgets/MainPage/app_bar.dart';
import 'package:prueba_flutter_2/widgets/MainPage/bottom_nav.dart';
import 'package:prueba_flutter_2/widgets/MainPage/search_bar.dart';
import 'package:prueba_flutter_2/widgets/MainPage/trending_book.dart';
import 'package:prueba_flutter_2/widgets/MainPage/continue_reading.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
    
        const   Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SearchBarFena(),
              Padding(
                padding:  EdgeInsets.only(bottom: 8.0),
                child:  TrendingBooksSection(),
              ),
              SizedBox(height: 16), 
            ],
          ),
        
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3, 
              color: Colors.transparent,
              child: const ContinueReadingSection(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
