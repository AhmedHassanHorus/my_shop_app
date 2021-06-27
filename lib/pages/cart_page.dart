import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/providers/cart.dart' show Cart;
import 'package:my_shop_app/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  static const route = '/cartPage';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6!.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartData),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                id: cartData.items.values.toList()[i].id,
                productId: cartData.items.keys.toList()[i],
                title: cartData.items.values.toList()[i].title,
                price: cartData.items.values.toList()[i].price,
                quantity: cartData.items.values.toList()[i].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final cartData;
  OrderButton(this.cartData);
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return isLoading == true
        ? CircularProgressIndicator(
            color: Theme.of(context).accentColor,
          )
        : FlatButton(
            onPressed: (widget.cartData.totalPrice <= 0 || isLoading == true)
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<Orders>(context, listen: false)
                        .addNewOrder(widget.cartData.items.values.toList(),
                            widget.cartData.totalPrice);
                    setState(() {
                      isLoading = false;
                    });
                    widget.cartData.clear();
                  },
            child: Text(
              'ORDER NOW',
            ),
            textColor: Theme.of(context).primaryColor,
          );
  }
}
