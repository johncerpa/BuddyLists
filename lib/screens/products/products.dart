import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movilfinalapp/models/product.dart';
import 'package:movilfinalapp/shared/constants.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  Product selectedProduct;
  final qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                'Choose a product',
                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20.0),
              listOfProducts(),
              SizedBox(
                height: 20.0,
              ),
              selectedProduct != null
                  ? Text('Selected product',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w600))
                  : SizedBox(),
              selectedProduct != null
                  ? productCard(selectedProduct)
                  : SizedBox(),
              SizedBox(height: 20.0),
              selectedProduct != null
                  ? Text('How many?',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w600))
                  : SizedBox(),
              quantityField(),
              SizedBox(height: 20.0),
              addButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget listOfProducts() {
    List<Product> products = [
      Product(name: 'Tomato', price: 4.0),
      Product(name: 'Pizza', price: 25.0),
      Product(name: 'Cheese', price: 6.0),
      Product(name: 'Apple', price: 3.0),
    ];

    return Container(
        height: 340.0,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, position) {
            var product = products[position];
            return productCard(product);
          },
        ));
  }

  Widget productCard(Product product) {
    return Card(
        child: Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListTile(
        leading: Icon(Icons.fastfood, size: 30.0),
        title: Row(
          children: <Widget>[
            Text(product.name, style: TextStyle(fontWeight: FontWeight.w500)),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Card(
                color: Colors.green,
                child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Price: \$${product.price.toString()}',
                        style: TextStyle(color: Colors.white))),
              ),
            )
          ],
        ),
        onTap: () {
          setState(() {
            selectedProduct = product;
          });
        },
      ),
    ));
  }

  Widget quantityField() {
    return selectedProduct != null
        ? TextField(
            controller: qtyController,
            decoration: InputDecoration(labelText: 'Enter the quantity'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
          )
        : SizedBox();
  }

  Widget addButton() {
    return selectedProduct != null
        ? RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)),
            color: appColor,
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop(SelectedProduct(
                  product: selectedProduct,
                  quantity: int.parse(qtyController.text)));
            },
          )
        : SizedBox();
  }
}
