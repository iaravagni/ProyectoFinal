import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'record_page.dart';
import 'report_page.dart';
import 'history_page.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget{
  @override
  _MyAppCardState createState() => _MyAppCardState();
}

class _MyAppCardState extends State<MyApp>{
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple[100],
        elevation: 6.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile' ),
          BottomNavigationBarItem(icon: Icon(Icons.fiber_manual_record_outlined), label: 'Record' ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Report' ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History' )
        ],
        currentIndex: _selectedIndex,
        onTap: onTapped
      ),
      body: PageView(
        controller: pageController,
        children: [
          Profile(),
          //Container(color: Colors.orange),
          Record(),
          Report(),
          //Container(color: Colors.black),
          History(),
        ],
      ),
      );
  }
}