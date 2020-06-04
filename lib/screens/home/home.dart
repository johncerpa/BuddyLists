import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/models/product.dart';
import 'package:movilfinalapp/screens/newProduct/newproduct.dart';
import 'package:movilfinalapp/screens/products/products.dart';
import 'package:movilfinalapp/shared/constants.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/home_vm.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
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
            floatingActionButton: _getFAB(model),
            body: model.state == ViewState.Busy
                ? Center(
                    child: Loading(),
                  )
                : homeView(model));
      },
    );
  }

  Widget homeView(HomeViewModel model) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(children: <Widget>[
                Text('Shopping list',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 20.0),
                model.selectedProducts.length > 0
                    ? listOfProducts(model)
                    : Text('No products added',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 20.0,
                            color: Colors.grey)),
                model.selectedProducts.length > 0
                    ? Text('Total',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w500))
                    : SizedBox(),
                model.selectedProducts.length > 0
                    ? Container(
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: totalView(model.selectedProducts))
                    : SizedBox(),
                updateListButton(model)
              ]),
            ),
          ),
        ),
      ],
    ));
  }

  Widget totalView(List<SelectedProduct> products) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: Colors.green,
      child: Container(
          width: 150.0,
          height: 50.0,
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Text('\$${getTotal(products)}',
                style: TextStyle(fontSize: 25.0, color: Colors.white)),
          )),
    );
  }

  String getTotal(List<SelectedProduct> products) {
    double total = 0.0;
    products.forEach((p) => total += (p.product.price * p.quantity));
    return total.toString();
  }

  Widget listOfProducts(HomeViewModel model) {
    return Container(
        height: 455.0,
        child: ListView.builder(
          itemCount: model.selectedProducts.length,
          itemBuilder: (context, position) {
            return productCard(model.selectedProducts[position].product,
                model.selectedProducts[position].quantity, position, model);
          },
        ));
  }

  Widget productCard(
      Product product, int quantity, int position, HomeViewModel model) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        model.removeProduct(position);
      },
      child: Card(
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
      )),
    );
  }

  Widget updateListButton(HomeViewModel model) {
    return model.selectedProducts.length > 0
        ? ButtonTheme(
            minWidth: 150.0,
            height: 40.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: appColor,
              child: Text('Update list', style: TextStyle(fontSize: 17)),
              onPressed: () async {
                try {
                  await model.postList();
                  final snackbar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('List updated!',
                        style: TextStyle(color: Colors.white)),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackbar);
                } catch (error) {
                  final snackbar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Could not update/post the list',
                        style: TextStyle(color: Colors.white)),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackbar);
                }
              },
            ),
          )
        : SizedBox();
  }

  Widget _getFAB(HomeViewModel model) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: appColor,
      foregroundColor: Colors.black,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.assignment_turned_in),
            backgroundColor: Colors.blue,
            onTap: () async {
              SelectedProduct selectedProduct = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Products()));

              model.addProductToCart(selectedProduct);
            },
            label: 'Add existing product',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.assignment_turned_in),
            backgroundColor: Colors.red,
            onTap: () async {
              ProductNew newProduct = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NewProduct()));

              if (newProduct != null) {
                model.addProductToCart(SelectedProduct(
                    product:
                        Product(name: newProduct.name, price: newProduct.price),
                    quantity: newProduct.quantity));
              }
            },
            label: 'Add new product',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.red)
      ],
    );
  }
}
