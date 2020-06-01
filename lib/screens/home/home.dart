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
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, model, child) {
        return Scaffold(
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
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(children: <Widget>[
              Text('Shopping list',
                  style:
                      TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              model.selectedProducts.length > 0
                  ? listOfProducts(model.selectedProducts)
                  : Text('No products added',
                      style: TextStyle(
                          fontWeight: FontWeight.w100, fontSize: 20.0)),
              updateListButton(model)
            ]),
          ),
        ),
      ),
    );
  }

  Widget listOfProducts(List<SelectedProduct> selectedProducts) {
    return Container(
        height: 550.0,
        child: ListView.builder(
          itemCount: selectedProducts.length,
          itemBuilder: (context, position) {
            return productCard(selectedProducts[position].product,
                selectedProducts[position].quantity);
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
              onPressed: () {
                model.postList();
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
