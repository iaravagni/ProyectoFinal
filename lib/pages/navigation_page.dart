import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'profile_page.dart';
import 'record_page.dart';
import 'report_page.dart';
import 'history_page.dart';

class Navigation extends StatefulWidget {
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
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
