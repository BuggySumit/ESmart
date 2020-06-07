import 'package:flutter/material.dart';
import '../helper/custom_route.dart';
import 'package:provider/provider.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/avtaar.png'),
            ),
          ),
          title: Text('User_Name'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('My Orders'),
          onTap: () {
            //  Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            Navigator.of(context).pushReplacement(
              CustomRoute(
                builder: (ctx) => OrdersScreen(),
              ),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).popAndPushNamed('/');
            Provider.of<Auth>(context, listen: false).logOut();
            //Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
          },
        )
      ],
    ));
  }
}
