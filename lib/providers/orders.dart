import 'package:flutter/foundation.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _ordersList = [];
  List<OrderItem> get ordersList {
    return [..._ordersList];
  }

  String? authToken;
  String? userId;
  Orders();
  Orders.fromOrders(this._ordersList, this.authToken, this.userId);

  Future fetchData() async {
    final url =
        'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    try {
      final fetchedData = json.decode(response.body);
      if (fetchedData == null) {
        return;
      }
      final List<OrderItem> newOrdersList = [];
      fetchedData.forEach((orderId, order) {
        newOrdersList.add(
          OrderItem(
            id: orderId,
            amount: order['amount'],
            dateTime: DateTime.parse(order['dateTime']),
            products: (order['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      price: item['price'],
                      quantity: item['quantity']),
                )
                .toList(),
          ),
        );
      });

      _ordersList = newOrdersList.reversed.toList();
      notifyListeners();
    } catch (error) {
      print('oh $error');
    }
  }

  Future addNewOrder(List<CartItem> products, double total) async {
    final time = DateTime.now();
    final url =
        'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': time.toIso8601String(),
          'products': products
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList()
        }));
    _ordersList.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: time,
          products: products),
    );
    notifyListeners();
  }
}
