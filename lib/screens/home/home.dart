import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/shared/constants.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/home_vm.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, model, child) {
        return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: appColor,
              elevation: 0.0,
              title: Text('Home', style: TextStyle(color: Colors.black)),
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
            floatingActionButton: FloatingActionButton(
              backgroundColor: appColor,
              onPressed: () {},
              child: Icon(Icons.add, color: Colors.black, size: 24.0),
            ),
            body: model.state == ViewState.Busy
                ? Center(
                    child: Loading(),
                  )
                : homeView(context));
      },
    );
  }

  Widget homeView(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(children: <Widget>[
            Text('Shopping list',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            listOfProducts()
          ]),
        ),
      ),
    );
  }

  Widget listOfProducts() {
    List<Product> products = [
      Product(name: 'Tomato', price: 4.0),
      Product(name: 'Pizza', price: 25.0),
      Product(name: 'Pizza', price: 25.0),
      Product(name: 'Pizza', price: 25.0),
      Product(name: 'Pizza', price: 25.0),
      Product(name: 'Pizza', price: 25.0),
      Product(name: 'Pizza', price: 25.0),
      Product(name: 'Pizza', price: 25.0),
    ];

    return Container(
        height: 570.0,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, position) {
            var product = products[position];
            return productCard(product, position);
          },
        ));
  }

  Widget productCard(Product product, int position) {
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
                    child: Text('Quantity: ${0}',
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class Product {
  String name;
  double price;

  Product({this.name, this.price});
}
