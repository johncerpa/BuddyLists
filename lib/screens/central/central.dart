import 'package:flutter/material.dart';
import 'package:movilfinalapp/screens/friends/friends.dart';
import 'package:movilfinalapp/screens/home/home.dart';
import 'package:movilfinalapp/shared/constants.dart';

class Central extends StatefulWidget {
  @override
  _CentralState createState() => _CentralState();
}

class _CentralState extends State<Central> {
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _children = [Home(), Friends()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: navBar(), body: _children[_selectedIndex]);
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
                    icon: Icon(Icons.shopping_cart, color: Colors.black),
                    title: Text('My List')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person, color: Colors.black),
                    title: Text('Friends')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.save, color: Colors.black),
                    title: Text('Save')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.book, color: Colors.black),
                    title: Text('History'))
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              onTap: _onItemTapped,
            ),
          ),
        ));
  }
}
