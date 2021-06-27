import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/edit_product_page.dart';
import 'package:my_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(
      {required this.id, required this.title, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EditProductPage.route,
                        arguments: id);
                  },
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .removeProduct(id);
                    } catch (error) {
                      print(error);
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            'failed to delete item',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
