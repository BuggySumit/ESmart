import 'dart:convert';
import 'package:flutter/Material.dart';
import '../models/http_exception.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
   
  ];

  final String authToken;
  final String userId;
  Products(this.authToken,this.userId,this._items);

//var _showFavoriteOnly=false;

  List<Product> get items {
//if(_showFavoriteOnly){
    //return
//}
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

// void showFavoriteOnly(){
//   _showFavoriteOnly=true;
//   notifyListeners();
// }
// void showAll(){
//   _showFavoriteOnly=false;
//   notifyListeners();
// }

  Future<void> fetchAndSetProducts([bool filterByUser= false]) async {
    final filterString = filterByUser? 'orderBy="creatorId"&equalTo="$userId"' :'';
    var url = '[YourDatabaseUrl]/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final List<Product> loadedProduct = [];
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if(extractedData==null){
        return;
      }
      url  =
        '[YourDatabaseUrl]/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse=await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: favoriteData==null ? false : favoriteData[prodId] ??false,
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = '[YourDatabaseUrl]/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('error');
      //throw error;
    }
  }

  void updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = '[YourDatabaseUrl]/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = '[YourDatabaseUrl]/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could Not delete product');
    }
    existingProduct = null;
  }
}
