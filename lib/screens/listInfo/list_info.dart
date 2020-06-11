import 'package:flutter/material.dart';
import 'package:movilfinalapp/models/product.dart';
import 'package:movilfinalapp/screens/chat/chat.dart';

class ListInfo extends StatefulWidget {
  final dynamic listInformation;
  ListInfo({this.listInformation});

  @override
  _ListInfoState createState() => _ListInfoState();
}

class _ListInfoState extends State<ListInfo> {
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
                '${widget.listInformation['data']['name']}\'s list',
                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20.0),
              listOfProducts(),
              SizedBox(height: 20.0),
              Text('Total',
                  style:
                      TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500)),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,children:<Widget>[total(),MaterialButton(child:Text("Chat" ,style:TextStyle(color:Colors.white) ,) , color: Colors.blue, onPressed: () {  Navigator.of(context).push(MaterialPageRoute(
                    
              builder: (context) => Chat(
                   widget.listInformation['data']['uid']
                  )));},)]),
            ],
          ),
        ),
      ),
    );
  }

  Widget total() {
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
            child: Text(
                '\$${getTotal(widget.listInformation['data']['products'])}',
                style: TextStyle(fontSize: 25.0, color: Colors.white)),
          )),
    );
  }

  Widget listOfProducts() {
    dynamic products = widget.listInformation['data']['products'];

    return Container(
        height: 400.0,
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

  String getTotal(dynamic products) {
    double total = 0.0;
    products.forEach((p) => total += (p['productPrice'] * p['quantity']));
    return total.toString();
  }
}
