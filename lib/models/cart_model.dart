import 'package:flutter/foundation.dart';
import 'package:template01/models/shopping_cart.dart';

class CartModel extends ChangeNotifier {
  List<ShoppingCartItem> _items = [];

  List<ShoppingCartItem> get items => _items;

  void addItem(ShoppingCartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(ShoppingCartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void updateItemQuantity(ShoppingCartItem item, int quantity) {
    int index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index].quantity = quantity;
      _items[index].total = _items[index].price * quantity;
      notifyListeners();
    }
  }
}