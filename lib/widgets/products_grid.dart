import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/providers/products_provider.dart';
import 'products_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFav;
  ProductsGrid(this._showFav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _showFav
          ? productsData.favoritesList.length
          : productsData.productsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: _showFav
            ? productsData.favoritesList[i]
            : productsData.productsList[i],
        child: ProductsItem(
            // id: productsData.productsList[i].id,
            // title: productsData.productsList[i].title,
            // imageUrl: productsData.productsList[i].imageUrl
            ),
      ),
    );
  }
}
