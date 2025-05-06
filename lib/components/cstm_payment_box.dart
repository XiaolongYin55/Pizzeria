import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/models/orders.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
import 'package:template01/cstm_pages/cstm_home.dart';
import 'package:template01/view_models/cart_view_model.dart';
import 'package:template01/view_models/dish_view_model.dart';
import 'package:template01/view_models/order_view_model.dart';

void showPaymentSuccessDialog({
  required BuildContext context,
  // required FirestoreService firestoreService,
  required DishesViewModel dishesViewModel,
  required ShoppingCartViewModel shoppingCartViewModel,
  required OrdersViewModel ordersViewModel,
  required Users user,
  required List<ShoppingCartItem> shoppingCartItems,
  required double totalPrice,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(             //19-35 新加的
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 4.0),
            Text('Successful'),
          ],
        ),
        content: ListTile(
          subtitle: Text('Your payment was done successfully.'),
        ),
        actions: [
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, // 修改
                side: BorderSide(color: Colors.deepPurple), // 修改
              ),


              onPressed:() async {
                for (var cartItem in shoppingCartItems) {
                  //~ get ordered dishes by name
                  var dish = await dishesViewModel.getDishByName(cartItem.name);
if (dish != null) {
  int updatedSalesVolume = dish.salesVolume + cartItem.quantity;
  Dishes updatedDish = Dishes(
    id: dish.id,
    name: dish.name,
    type: dish.type,
    description: dish.description,
    image: dish.image,
    price: dish.price,
    quantity: dish.quantity,
    size: dish.size,
    memberPrice: dish.memberPrice,
    imageUrl: dish.imageUrl,
    salesVolume: updatedSalesVolume,
    soldOut: dish.soldOut,
    createDate: dish.createDate,
    updateDate: Timestamp.now(),
  );
  await dishesViewModel.updateDish(updatedDish);
}
                }
                //~ when finish payment delete user's shopping cart
                await shoppingCartViewModel.clearUserCart(user.username);

                //~ set dishes[] of new order
                List<Map<String, dynamic>> dishes = shoppingCartItems
                    .map((item) => {
                  'name': item.name,
                  'quantity': item.quantity,
                  'price': item.price,
                })
                    .toList();

                Orders order = Orders(
                    id: '', // 你可以在这里生成一个唯一的订单 ID
                    username: user.username,
                    total: totalPrice,
                    dishes: dishes,
                    createDate: DateTime.now(),
                    updateDate: DateTime.now());
                //~ create an order by VM
                await ordersViewModel.createOrder(order);

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => CustomerHome(user: user)),
                );
              },
              child: Text('OK'),
            ),
          ),
        ],
      );
    },
  );
}
