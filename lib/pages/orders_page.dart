import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/orders.dart' show Orders;
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/widgets/order_item.dart';

class OrdersPage extends StatefulWidget {
  static const route = '/orders_page';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // var isLoading = false;
  @override
  void initState() {
    // isLoading = true;
    //
    // Provider.of<Orders>(context, listen: false)
    //     .fetchData()
    //     .then((_) => setState(() {
    //           isLoading = false;
    //         }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).accentColor,
              ),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('there is a problem'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.ordersList.length,
                  itemBuilder: (ctx, i) => OrderItem(
                    order: orderData.ordersList[i],
                  ),
                ),
              );
            }
          }
        },
      ),
      // body: isLoading == true
      //     ? Center(
      //         child: CircularProgressIndicator(
      //           color: Theme.of(context).accentColor,
      //         ),
      //       )
      //     : ListView.builder(
      //         itemCount: orderData.ordersList.length,
      //         itemBuilder: (ctx, i) => OrderItem(
      //           order: orderData.ordersList[i],
      //         ),
      //       ),
      drawer: AppDrawer(),
    );
  }
}
