import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/models/product.dart';
import 'package:movilfinalapp/screens/products/products.dart';
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
            floatingActionButton: FloatingActionButton(
              backgroundColor: appColor,
              onPressed: () async {
                // Launch products view
                SelectedProduct selectedProduct = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Products()));

                model.addProductToCart(selectedProduct);
              },
              child: Icon(Icons.add, color: Colors.black, size: 24.0),
            ),
            body: model.state == ViewState.Busy
                ? Center(
                    child: Loading(),
                  )
                : homeView(model.selectedProducts));
      },
    );
  }

  Widget homeView(List<SelectedProduct> selectedProducts) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(children: <Widget>[
            Text('Shopping list',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            listOfProducts(selectedProducts)
          ]),
        ),
      ),
    );
  }

  Widget listOfProducts(List<SelectedProduct> selectedProducts) {
    return Container(
        height: 570.0,
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
}
