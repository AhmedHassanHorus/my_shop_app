import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});
  Future toggleIsFavorite(String authToken, String userId) async {
    final url = Uri.parse(
        'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/$userId/$id.json?auth=$authToken');
    final oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        print(response.statusCode);
        isFavorite = oldFavorite;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      isFavorite = oldFavorite;
      notifyListeners();
    }
  }
}
