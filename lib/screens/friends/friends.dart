import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/models/user.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/friends_vm.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return BaseView<FriendsViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    model.logout();
                  },
                  icon:
                      Icon(Icons.exit_to_app, color: Colors.black, size: 24.0),
                )
              ]),
          body: model.state == ViewState.Busy
              ? Center(child: Loading())
              : friendsView(model.friends),
        );
      },
    );
  }

  Widget friendsView(List<User> friends) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(children: <Widget>[
            Text('My friends',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            friends.length > 0
                ? listOfFriends(friends)
                : Text('No friends available',
                    style:
                        TextStyle(fontWeight: FontWeight.w100, fontSize: 20.0))
          ]),
        ),
      ),
    );
  }

  Widget listOfFriends(List<User> friends) {
    return Container(
        height: 570.0,
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, position) {
            return friendCard(friends[position]);
          },
        ));
  }

  Widget friendCard(User user) {
    return Card(
        child: Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListTile(
          leading: Icon(Icons.fastfood, size: 30.0),
          title: Text('Email', style: TextStyle(fontWeight: FontWeight.w500))),
    ));
  }
}
