import 'package:flutter/material.dart';
import 'package:movilfinalapp/models/product.dart';

Color appColor = Colors.yellow[600];

class SelectedProduct {
  Product product;
  int quantity;

  SelectedProduct({this.product, this.quantity});

  Map<String, dynamic> toJson() => _selectedProductToJson(this);

  Map<String, dynamic> _selectedProductToJson(SelectedProduct selectedProduct) {
    return <String, dynamic>{
      'productName': selectedProduct.product.name,
      'productPrice': selectedProduct.product.price,
      'quantity': selectedProduct.quantity
    };
  }
}
