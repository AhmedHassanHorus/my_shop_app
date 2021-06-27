import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addCartItem(String productId, String productTitle, double productPrice) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (lastCartItem) => CartItem(
            id: lastCartItem.id,
            title: lastCartItem.title,
            price: lastCartItem.price,
            quantity: lastCartItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: productId,
            title: productTitle,
            price: productPrice,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void deleteItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String proId) {
    if (!_items.containsKey(proId)) {
      return;
    }
    if (_items[proId]!.quantity > 1) {
      _items.update(
        proId,
        (lastCartItem) => CartItem(
            id: lastCartItem.id,
            title: lastCartItem.title,
            price: lastCartItem.price,
            quantity: lastCartItem.quantity - 1),
      );
    } else {
      _items.remove(proId);
    }
    notifyListeners();
  }
}
