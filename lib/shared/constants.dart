import 'package:flutter/material.dart';
import 'package:movilfinalapp/models/product.dart';

Color appColor = Color.fromRGBO(253, 253, 150, 1.0);

class SelectedProduct {
  Product product;
  int quantity;

  SelectedProduct({this.product, this.quantity});
}
