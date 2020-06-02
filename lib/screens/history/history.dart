import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/screens/historyListInfo/history_list_info.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/history_vm.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BaseView<HistoryViewModel>(
      onModelReady: (model) => getHistoryLists(model),
      builder: (context, model, child) {
        return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  onPressed: () async {
                    model.logout();
                  },
                  icon:
                      Icon(Icons.exit_to_app, color: Colors.black, size: 24.0),
                )
              ],
            ),
            body: model.state == ViewState.Busy
                ? Center(
                    child: Loading(),
                  )
                : saveView(model));
      },
    );
  }

  getHistoryLists(HistoryViewModel model) async {
    try {
      await model.getHistoryLists();
    } catch (error) {
      print(error);
    }
  }

  Widget saveView(HistoryViewModel model) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(children: <Widget>[
              Text('My list',
                  style:
                      TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              model.listsService.historyLists.length > 0
                  ? userLists(model)
                  : Text('Save your list, please',
                      style: TextStyle(
                          fontWeight: FontWeight.w100, fontSize: 20.0)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget userLists(HistoryViewModel model) {
    return Container(
        height: 410.0,
        child: ListView.builder(
          itemCount: model.historyLists.length,
          itemBuilder: (context, position) {
            return listCard(model.historyLists[position], model);
          },
        ));
  }

  Widget listCard(dynamic list, HistoryViewModel model) {
    String name = list['name'];

    return Card(
        child: Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListTile(
        leading: Icon(Icons.list, size: 30.0),
        title: Text('List owner: $name',
            style: TextStyle(fontWeight: FontWeight.w500)),
        onTap: () {
          // Show owner name and products
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HistoryListInfo(
                    listInformation: list,
                  )));
        },
      ),
    ));
  }
}
