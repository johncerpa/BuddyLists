import 'package:flutter/material.dart';
import 'package:movilfinalapp/screens/friends/friends.dart';
import 'package:movilfinalapp/screens/history/history.dart';
import 'package:movilfinalapp/screens/home/home.dart';
import 'package:movilfinalapp/screens/save/save.dart';
import 'package:movilfinalapp/services/lists_service.dart';
import 'package:movilfinalapp/shared/constants.dart';

import '../../locator.dart';

class Central extends StatefulWidget {
  @override
  _CentralState createState() => _CentralState();
}

class _CentralState extends State<Central> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final listsService = locator<ListsService>();
  final List<Widget> _children = [Home(), Friends(), Save(), History()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: navBar(),
        body: _children[_selectedIndex]);
  }

  Widget navBar() {
    return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10)
            ],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: Theme(
            data: ThemeData(canvasColor: appColor),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    title: Text('My List')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('Friends')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.save), title: Text('Save')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.book), title: Text('History'))
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              selectedIconTheme: IconThemeData(color: Colors.white),
              onTap: _onItemTapped,
            ),
          ),
        ));
  }

  _onItemTapped(int index) {
    if (!listsService.isClosed) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      final snackbar = SnackBar(
        content: Text('Sorry, you cannot modify lists anymore'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}
