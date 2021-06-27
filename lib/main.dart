import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/User_products_page.dart';
import 'package:my_shop_app/pages/auth_page.dart';
import 'package:my_shop_app/pages/cart_page.dart';
import 'package:my_shop_app/pages/edit_product_page.dart';
import 'package:my_shop_app/pages/orders_page.dart';
import 'package:my_shop_app/pages/product_detail_page.dart';
import 'package:my_shop_app/pages/products_overview_page.dart';
import 'package:my_shop_app/providers/auth.dart';
import 'package:my_shop_app/providers/orders.dart';
import 'package:my_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (ctx, auth, previousProducts) => Products.fromProducts(
              previousProducts == null ? [] : previousProducts.productsList,
              auth.token,
              auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, previousOrders) => Orders.fromOrders(
            previousOrders == null ? [] : previousOrders.ordersList,
            auth.token,
            auth.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        return MaterialApp(
          title: 'MyShop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverViewPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashPage()
                          : AuthPage()),
          routes: {
            // '/': (ctx) => ProductsOverViewPage(),
            ProductDetailPage.route: (ctx) => ProductDetailPage(),
            CartPage.route: (ctx) => CartPage(),
            OrdersPage.route: (ctx) => OrdersPage(),
            UserProductsPage.route: (ctx) => UserProductsPage(),
            EditProductPage.route: (ctx) => EditProductPage(),
          },
        );
      }),
    );
  }
}
