import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movilfinalapp/models/product.dart';
import 'package:movilfinalapp/shared/constants.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final qtyController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                'Add a new product',
                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(height: 20.0),
              nameField(),
              SizedBox(height: 20.0),
              priceField(),
              SizedBox(height: 20.0),
              quantityField(),
              SizedBox(height: 20.0),
              addButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(labelText: 'Enter the name'),
    );
  }

  Widget priceField() {
    return TextField(
        controller: priceController,
        decoration: InputDecoration(labelText: 'Enter the price'),
        keyboardType: TextInputType.number);
  }

  Widget quantityField() {
    return TextField(
      controller: qtyController,
      decoration: InputDecoration(labelText: 'Enter the quantity'),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
    );
  }

  Widget addButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.black)),
      color: appColor,
      child: Text('Add'),
      onPressed: () {
        try {
          double price = double.parse(priceController.text);
          Navigator.of(context).pop(ProductNew(
              name: nameController.text,
              price: price,
              quantity: int.parse(qtyController.text)));
        } catch (error) {
          SnackBar snackbar = SnackBar(
              content: Text('The price is badly formatted, type it again'));
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
  }
}

class ProductNew {
  String name;
  double price;
  int quantity;
  ProductNew({this.name, this.price, this.quantity});
}
