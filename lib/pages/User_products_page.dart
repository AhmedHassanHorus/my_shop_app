import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/edit_product_page.dart';
import 'package:my_shop_app/providers/products_provider.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:my_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsPage extends StatelessWidget {
  static const route = '/user_products_page';
  Future refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductPage.route);
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).accentColor,
                    ),
                  )
                : RefreshIndicator(
                    color: Theme.of(context).accentColor,
                    onRefresh: () {
                      return refreshProducts(context);
                    },
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => UserProductItem(
                              id: productsData.productsList[i].id,
                              title: productsData.productsList[i].title,
                              imageUrl: productsData.productsList[i].imageUrl),
                          itemCount: productsData.productsList.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
