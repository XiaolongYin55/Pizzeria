import 'package:flutter/material.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
import 'package:template01/services/firestore.dart';
import 'package:template01/cstm_pages/shopping_cart.dart';
import 'package:template01/view_models/cart_view_model.dart';

class ShoppingCartArea extends StatelessWidget {
  final FirestoreService firestoreService;
  final ShoppingCartViewModel shoppingCartViewModel;
  final Users user;

  const ShoppingCartArea({
    Key? key,
    required this.firestoreService,
    required this.shoppingCartViewModel,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: shoppingCartViewModel.getShoppingCartItems(user.username),
      builder: (BuildContext context,
          AsyncSnapshot<List<ShoppingCartItem>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final shoppingCartItems = snapshot.data!;
          int itemCount = shoppingCartItems.length;
          double totalPrice = shoppingCartItems.fold(
              0, (sum, item) => sum + item.total); // 计算总价
          return BottomAppBar(
            child: ListTile(
              title: Text('Shopping Cart ($itemCount items)'),
              subtitle: Text('\$${totalPrice.toStringAsFixed(1)}'),
              trailing: ElevatedButton(
                child: Text('Shopping Cart'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCartPage(
                        shoppingCartItems: shoppingCartItems,
                        totalPrice: totalPrice,
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
