import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'profile_page.dart';
import 'record_page.dart';
import 'report_page.dart';
import 'history_page.dart';
import 'loading_page.dart';

import 'package:myapp/Resources/user_info.dart';


UserData actualUser = new UserData();

class Navigation extends StatefulWidget {
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void updateSelectedIndex(int index){
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }



  void initState(){
    super.initState();
    if (actualUser.name == ''){
      userInfo().then(
              (UserData s) => setState((){
            actualUser = s;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (actualUser.name == '') {
      return Loading();
    } else {
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
        onTap: updateSelectedIndex
      ),
      body: PageView(
        controller: pageController,
        children: [
          Profile(updateSelectedIndex),
          Record(),
          Report(),
          History(),
        ],
      ),
      );


    }
  }
}
