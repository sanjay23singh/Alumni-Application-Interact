import 'package:alumni/modals.dart/universalVariables.dart';
import 'package:alumni/screens/MainScreens/PostScreen.dart';
import 'package:alumni/screens/MainScreens/add.dart';
import 'package:alumni/screens/MainScreens/EditInfo.dart';
import 'package:alumni/screens/MainScreens/searchScreen.dart';
import 'package:alumni/screens/MainScreens/userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot>list;
  HomeScreen(this.list);
  @override
  _HomeScreenState createState() => _HomeScreenState(list);
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  List<QueryDocumentSnapshot>list;
  _HomeScreenState(this.list);

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //to change screeen pageView
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          PostScreen(list),
          SearchScreen(),
          AddPost(),
          EditInfo(),
          ProfilePage(),
        ],
        //when we slide the screen the bottomNavigationBar also sweeps
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color:  UniversalVariables.separatorColor,
          child: CupertinoTabBar(
            backgroundColor:  UniversalVariables.separatorColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: (_selectedIndex == 0)
                        ? Color(0xff0077d7)
                        : Color(0xff8f8f8f)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    color: (_selectedIndex == 1)
                        ? Color(0xff0077d7)
                        : Color(0xff8f8f8f)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add,
                    color: (_selectedIndex == 2)
                        ? Color(0xff0077d7)
                        : Color(0xff8f8f8f)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit,
                    color: (_selectedIndex == 3)
                        ? Color(0xff0077d7)
                        : Color(0xff8f8f8f)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle,
                    color: (_selectedIndex == 4)
                        ? Color(0xff0077d7)
                        : Color(0xff8f8f8f)),
              ),
            ],
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
          ),

      ),
    );
  }
}
