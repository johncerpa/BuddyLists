import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/models/product.dart';
import 'package:movilfinalapp/shared/constants.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/save_vm.dart';

class Save extends StatefulWidget {
  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String state = 'Close';

  @override
  Widget build(BuildContext context) {
    return BaseView<SaveViewModel>(
      builder: (context, model, child) {
        return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text: "Buddy",
                        style: TextStyle(color: kSecondaryColor)),
                    TextSpan(
                        text: "Lists", style: TextStyle(color: kPrimaryColor))
                  ])),
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

  Widget saveView(SaveViewModel model) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(children: <Widget>[
              Text('My list',
                  style:
                      TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              model.listsService.fbUserList != null
                  ? listOfProducts(model)
                  : Text('Save your list first',
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 20.0,
                          color: Colors.grey)),
              model.listsService.friendList != null
                  ? Text('Friend list',
                      style: TextStyle(
                          fontSize: 36.0, fontWeight: FontWeight.bold))
                  : SizedBox(),
              model.listsService.friendList != null
                  ? friendList(model)
                  : SizedBox(),
              SizedBox(height: 15.0),
              model.listsService.fbUserList != null
                  ? Text('Total',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w500))
                  : SizedBox(),
              model.listsService.fbUserList != null
                  ? totalView(model)
                  : SizedBox(),
              SizedBox(height: 10.0),
              model.listsService.fbUserList != null
                  ? stateButton(model)
                  : SizedBox(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget stateButton(SaveViewModel model) {
    return ButtonTheme(
      minWidth: 150.0,
      height: 40.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        color: appColor,
        child: Text('$state', style: TextStyle(fontSize: 17)),
        onPressed: () async {
          if (state == 'Close') {
            // Change button name
            setState(() {
              state = 'Finish';
            });

            // Inform user
            final snackbar = SnackBar(
                content: Text('Lists cannot be modified anymore'),
                backgroundColor: Colors.blue);
            _scaffoldKey.currentState.showSnackBar(snackbar);

            // Block user from getting to other views
            model.listsService.isClosed = true;
          } else {
            // finalize => update lists with finished: true
            try {
              await model.finishLists();
              // Inform user
              final snackbar = SnackBar(
                  content: Text('Finished!'), backgroundColor: Colors.green);
              _scaffoldKey.currentState.showSnackBar(snackbar);
            } catch (error) {
              // firebase error
            }
          }
        },
      ),
    );
  }

  Widget totalView(SaveViewModel model) {
    return Card(
      color: Colors.green,
      child: Container(
          width: 150.0,
          height: 50.0,
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Text('\$${getTotal(model)}',
                style: TextStyle(fontSize: 25.0, color: Colors.white)),
          )),
    );
  }

  String getTotal(SaveViewModel model) {
    double total = 0.0;
    final fList = model.listsService.friendList;
    final uList = model.listsService.userList;
    uList.forEach((p) => total += (p.product.price * p.quantity));

    if (fList != null) {
      fList['data']['products']
          .forEach((p) => total += (p['productPrice'] * p['quantity']));
    }

    return total.toString();
  }

  Widget listOfProducts(SaveViewModel model) {
    final userList = model.listsService.userList;
    return Container(
        height: 200.0,
        child: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, position) {
            return productCard(
                userList[position].product, userList[position].quantity);
          },
        ));
  }

  Widget productCard(Product product, int quantity) {
    return Card(
        child: Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListTile(
        leading: Icon(Icons.fastfood, size: 30.0),
        title:
            Text(product.name, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Container(
          margin: EdgeInsets.only(
            top: 5.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                color: Colors.green,
                child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Price: \$${product.price.toString()}',
                        style: TextStyle(color: Colors.white))),
              ),
              Card(
                color: Colors.blue,
                child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Quantity: $quantity',
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget friendList(SaveViewModel model) {
    dynamic products = model.listsService.friendList['data']['products'];

    return Container(
        height: 200.0,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, position) {
            dynamic p = products[position];
            Product product =
                Product(name: p['productName'], price: p['productPrice']);
            int quantity = p['quantity'];
            return productCard(product, quantity);
          },
        ));
  }
}
