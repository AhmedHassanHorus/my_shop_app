import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:my_shop_app/providers/product.dart';

import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/product_detail_page.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/providers/auth.dart';

class ProductsItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductsItem({required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailPage.route, arguments: product.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    product.toggleIsFavorite(
                        authData.token as String, authData.userId as String);
                  },
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addCartItem(product.id, product.title, product.price);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item added to the cart'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
