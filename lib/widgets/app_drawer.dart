import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/orders_page.dart';
import 'package:my_shop_app/pages/User_products_page.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello User'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, OrdersPage.route),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Your Products'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, UserProductsPage.route),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
                Provider.of<Auth>(context, listen: false).logOut();
              }),
        ],
      ),
    );
  }
}
