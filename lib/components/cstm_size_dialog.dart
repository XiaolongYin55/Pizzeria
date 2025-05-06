import 'package:flutter/material.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
import 'package:template01/view_models/cart_view_model.dart';
import 'package:template01/view_models/dish_view_model.dart';

// ignore: must_be_immutable
class SizeDialog extends StatefulWidget {
  final Dishes dish;
  final Users user;
  final DishesViewModel dishesViewModel;
  final ShoppingCartViewModel shoppingCartViewModel;
  List<ShoppingCartItem> shoppingCartItems = [];
   SizeDialog({
    required this.dish,
    required this.user,
    required this.dishesViewModel,
    required this.shoppingCartViewModel,
  });

  @override
  _SizeDialogState createState() => _SizeDialogState();
}

class _SizeDialogState extends State<SizeDialog> {
  String size = '9 in';
  double priceToAdd = 0.0;

  @override
  void initState() {
    super.initState();
    double originalPrice = widget.dish.price;
    double discountedPrice =
        widget.dish.memberPrice ? originalPrice * 0.8 : originalPrice;
    priceToAdd =
        widget.user.role == 'CUSTOMER' ? discountedPrice : originalPrice;
  }

  Future<void> _showSizeDialog(BuildContext context) async {
    if (widget.dish.soldOut) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This item is sold out!'),
          backgroundColor: Colors.red, // 设置消息框的背景颜色为红色
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Choose Size', style: TextStyle(color: Colors.deepPurple)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('9 in'),
                    leading: Radio<String>(
                      value: '9 in',
                      groupValue: size,
                      onChanged: (String? value) {
                        setState(() {
                          size = value!;
                          double originalPrice = widget.dish.price;
                          double discountedPrice = widget.dish.memberPrice
                              ? originalPrice * 0.8
                              : originalPrice;
                          priceToAdd = widget.user.role == 'CUSTOMER'
                              ? discountedPrice
                              : originalPrice;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('12 in'),
                    leading: Radio<String>(
                      value: '12 in',
                      groupValue: size,
                      onChanged: (String? value) {
                        setState(() {
                          size = value!;
                          double originalPrice = widget.dish.price;
                          double discountedPrice = widget.dish.memberPrice
                              ? originalPrice * 0.8
                              : originalPrice;
                          priceToAdd = widget.user.role == 'CUSTOMER'
                              ? discountedPrice + 10
                              : originalPrice + 10;
                        });
                      },
                    ),
                  ),
                  Text('Price: \$${priceToAdd.toStringAsFixed(1)}',
                      style: TextStyle(color: Colors.deepPurple)),
                  ElevatedButton(
                    child: Text('Add to Cart'),
                    onPressed: () async {
                      ShoppingCartItem cartItem = ShoppingCartItem(
                        id: widget.dish.id,
                        name: widget.dish.name,
                        type: widget.dish.type,
                        imageUrl: widget.dish.imageUrl,
                        price: priceToAdd,
                        quantity: 1,
                        total: priceToAdd,
                        username: widget.user.username,
                      );
                      //~ insert cart to DB
                      await widget.shoppingCartViewModel.addCartItem(cartItem);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Item added to cart!'),
                          backgroundColor: Colors.green, // 设置消息框的背景颜色为绿色
                          duration: Duration(milliseconds: 500),
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_circle, color: Colors.deepPurple),
      onPressed: () => _showSizeDialog(context),
    );
  }
}
