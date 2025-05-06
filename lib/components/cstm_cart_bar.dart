import 'package:flutter/material.dart';
import 'package:template01/cstm_pages/shopping_cart.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
import 'package:template01/view_models/cart_view_model.dart';

class ShoppingCartBar extends StatelessWidget {
  final ShoppingCartViewModel shoppingCartViewModel;
  final Users user;

  ShoppingCartBar({required this.user, required this.shoppingCartViewModel});

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
          double totalPrice =
          shoppingCartItems.fold(0, (sum, item) => sum + item.total);
          return BottomAppBar(
            color: Colors.white,
            shape: CircularNotchedRectangle(),
            child: Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shopping Cart',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '$itemCount items',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100], // 设置按钮背景颜色
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'View Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
