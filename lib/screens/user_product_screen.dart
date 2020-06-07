import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refreshProduct(BuildContext context) async{
  await  Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yours Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
              builder:(ctx,snapshot) => snapshot.connectionState==ConnectionState.waiting ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
          onRefresh: ()=>_refreshProduct(context),
                child: Consumer<Products>(
                            builder:(ctx,productData,_) =>Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
                  itemCount: productData.items.length,
                  itemBuilder: (_, i) => Column(
                        children: <Widget>[
                          UserProductItem(
                              productData.items[i].id,
                              productData.items[i].title,
                              productData.items[i].imageUrl),
                          Divider(),
                        ],
                      )),
          ),
                ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
