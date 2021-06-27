import 'dart:io';

import 'package:flutter/foundation.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _productsList = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String? authToken;
  String? userId;
  Products();
  Products.fromProducts(this._productsList, this.authToken, this.userId);

  List<Product> get productsList {
    return [..._productsList];
  }

  List<Product> get favoritesList {
    return _productsList
        .where((element) => element.isFavorite == true)
        .toList();
  }

  Product findById(proId) {
    return _productsList.firstWhere((pro) => proId == pro.id);
  }

  Future fetchData([bool filterByUser = false]) async {
    try {
      var url;
      if (filterByUser) {
        url =
            'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
      } else {
        url =
            'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken';
      }

      final response = await http.get(Uri.parse(url));
      url =
          'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      try {
        final favoriteData = json.decode(favoriteResponse.body);
        final fetchedData = json.decode(response.body) as Map<String, dynamic>;

        final List<Product> newProductsList = [];
        fetchedData.forEach((prodId, prod) {
          dynamic price = prod['price'];
          newProductsList.add(
            Product(
              id: prodId,
              title: prod['title'],
              price: price.toDouble(),
              description: prod['description'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
              imageUrl: prod['imageUrl'],
            ),
          );
        });
        _productsList = newProductsList;
        print(_productsList);
      } catch (error) {
        print('fetchError:$error');
        _productsList = [];
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future addProduct(Product product) async {
    final url =
        'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'creatorId': userId,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }),
      );
      print(json.decode(response.body)['name']);
      final productWithId = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _productsList.add(productWithId);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future editProduct(Product product) async {
    int index = _productsList.indexWhere((element) => element.id == product.id);
    final url =
        'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/products/${product.id}.json?auth=$authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }));
    _productsList[index] = product;
    notifyListeners();
  }

  Future removeProduct(String id) async {
    final url =
        'https://my-shop-app-ed857-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final proIndex = _productsList.indexWhere((pro) => id == pro.id);
    final proAtIndex = _productsList[proIndex];
    _productsList.removeAt(proIndex);
    notifyListeners();
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _productsList.insert(proIndex, proAtIndex);
        notifyListeners();
        throw HttpException('Could not remove item');
      }
    } catch (error) {
      _productsList.insert(proIndex, proAtIndex);
      notifyListeners();
      throw error;
    }
  }
}
