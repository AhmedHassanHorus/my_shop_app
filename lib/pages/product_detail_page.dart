import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/providers/products_provider.dart';

class ProductDetailPage extends StatelessWidget {
  static String route = '/products_detail_page';

  @override
  Widget build(BuildContext context) {
    final proId = ModalRoute.of(context)!.settings.arguments;
    final product =
        Provider.of<Products>(context, listen: false).findById(proId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
