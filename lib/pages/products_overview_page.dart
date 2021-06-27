import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/cart_page.dart';
import 'package:my_shop_app/providers/products_provider.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:my_shop_app/widgets/products_grid.dart';
import 'package:my_shop_app/widgets/badge.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:provider/provider.dart';

enum Show {
  favorites,
  all,
}

class ProductsOverViewPage extends StatefulWidget {
  @override
  _ProductsOverViewPageState createState() => _ProductsOverViewPageState();
}

class _ProductsOverViewPageState extends State<ProductsOverViewPage> {
  bool _showFavorites = false;
  var isInit = true;
  var isLoading = false;
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });

      Provider.of<Products>(context).fetchData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (Show selectedValue) {
              switch (selectedValue) {
                case Show.favorites:
                  setState(() {
                    _showFavorites = true;
                  });

                  break;
                case Show.all:
                  setState(() {
                    _showFavorites = false;
                  });
                  break;
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('only favorites'),
                value: Show.favorites,
              ),
              PopupMenuItem(
                child: Text('show all'),
                value: Show.all,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch as Widget,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartPage.route);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).accentColor,
              ),
            )
          : ProductsGrid(_showFavorites),
    );
  }
}
