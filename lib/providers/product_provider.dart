import 'package:actividad_desis/models/product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  Product? _product;
  Product? get product => _product;

  final List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> get products => _products;

  void setProduct(Product product) {
    _product = product;
    notifyListeners();
  }

  void deleteProduct() {
    _product = null;
    notifyListeners();
  }

  void addToProductList(Map<String, dynamic> ticket) {
    _products.add(ticket);
    notifyListeners();
  }

  int get totalAmount {
    return _products.fold(
      0,
      (sum, product) {
        final totalValue = product['totalValue'];

        return sum +
            (totalValue is int
                ? totalValue
                : int.tryParse(totalValue.toString()) ?? 0);
      },
    );
  }

  void removeProductToList(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  void removeAllProductList() {
    _products.clear();
    notifyListeners();
  }
}
