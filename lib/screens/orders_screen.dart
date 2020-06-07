import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Order;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body:  FutureBuilder(future:Provider.of<Order>(context, listen: false).fetchAndSetOrder(),builder: (ctx,dataSnapshot){
        if(dataSnapshot.connectionState==ConnectionState.waiting){
        return    Center(
              child: CircularProgressIndicator(),
            );
        }
        else{
            return  Consumer<Order>(builder:(ctx,orderData,child)=>ListView.builder(
              itemCount: orderData.order.length,
              itemBuilder: (ctx, i) => OrderItem(orderData.order[i]))); 
        }
      
      }
    ),);
  }
}
