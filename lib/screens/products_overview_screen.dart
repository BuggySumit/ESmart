import 'package:flutter/material.dart';
import 'package:meal_app/providers/cart.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../providers/products.dart';

enum filterOtions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOlnyFavorite = false;
  var _isInit=true;
  var _isLoading=false;

  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndSetProducts();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
    _isLoading=true;
       
      });
       Provider.of<Products>(context).fetchAndSetProducts().then((_){
       setState(() {
        _isLoading=false;  
       });
       
      });
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esmart'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filterOtions selectedValue) {
              setState(() {
                if (selectedValue == filterOtions.Favorites) {
                  _showOlnyFavorite = true;
                } else {
                  _showOlnyFavorite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: filterOtions.Favorites,
              ),
              PopupMenuItem(
                child: Text('ShowAll'),
                value: filterOtions.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed:()=> Navigator.of(context).pushNamed(CartScreen.routeName)),
          ),
        ],
      ),
      drawer: AppDrawer(),
     
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: null,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.category, color: Colors.white),
                onPressed: null,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: null,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.face, color: Colors.white),
                onPressed: null,
              ),
            ),
          ],
        ),
      ),
     body:_isLoading? Center(child: CircularProgressIndicator(),) :ProductsGrid(_showOlnyFavorite),
    );
  }
}
