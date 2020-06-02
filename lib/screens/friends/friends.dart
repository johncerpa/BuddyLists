import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/screens/listInfo/list_info.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/friends_vm.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  dynamic selectedList;

  @override
  Widget build(BuildContext context) {
    return BaseView<FriendsViewModel>(
      onModelReady: (model) => getLists(model),
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
              : friendsView(model),
        );
      },
    );
  }

  Widget friendsView(FriendsViewModel model) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(children: <Widget>[
            Text('Friends lists',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            model.lists.length > 0
                ? listOfLists(model)
                : Text('No friends lists available',
                    style:
                        TextStyle(fontWeight: FontWeight.w100, fontSize: 20.0)),
            model.friendList != null
                ? Text('Selected list',
                    style:
                        TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold))
                : SizedBox(),
            model.friendList != null
                ? listCard(model.friendList, model)
                : SizedBox()
          ]),
        ),
      ),
    );
  }

  Widget listOfLists(FriendsViewModel model) {
    return Container(
        height: 410.0,
        child: ListView.builder(
          itemCount: model.lists.length,
          itemBuilder: (context, position) {
            return listCard(model.lists[position], model);
          },
        ));
  }

  Widget listCard(dynamic list, FriendsViewModel model) {
    String name = list['data']['name'];

    return Card(
        child: Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListTile(
        leading: Icon(Icons.list, size: 30.0),
        title: Text('List owner: $name',
            style: TextStyle(fontWeight: FontWeight.w500)),
        onLongPress: () {
          // Show owner name and products
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListInfo(
                    listInformation: list,
                  )));
        },
        onTap: () {
          model.setFriendList(list);
          setState(() {
            selectedList = list;
          });
        },
      ),
    ));
  }

  getLists(FriendsViewModel model) async {
    try {
      await model.getLists();
    } catch (error) {
      // Could not load the lists
    }
  }
}
