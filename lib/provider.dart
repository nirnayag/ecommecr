import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> product) {
    cart.add(product);
    notifyListeners(); // Notify listeners to update the UI
  }



  void removeFromCart(Map<String, dynamic> product) {
    cart.remove(product);
    notifyListeners();
  }

  bool contains(Map<String, dynamic> product) {
    return cart.contains(product);
  }
}
