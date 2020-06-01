import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
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
              : friendsView(model.lists),
        );
      },
    );
  }

  Widget friendsView(List<dynamic> lists) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(children: <Widget>[
            Text('Friends lists',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            lists.length > 0
                ? listOfLists(lists)
                : Text('No friends lists available',
                    style:
                        TextStyle(fontWeight: FontWeight.w100, fontSize: 20.0))
          ]),
        ),
      ),
    );
  }

  Widget listOfLists(List<dynamic> lists) {
    return Container(
        height: 570.0,
        child: ListView.builder(
          itemCount: lists.length,
          itemBuilder: (context, position) {
            return listCard(lists[position]);
          },
        ));
  }

  Widget listCard(dynamic list) {
    return Card(
        child: Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListTile(
        leading: Icon(Icons.list, size: 30.0),
        title: Text('List owner: ${list['name']}',
            style: TextStyle(fontWeight: FontWeight.w500)),
        onTap: () {
          // Show owner name and products
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
