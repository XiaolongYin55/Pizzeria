import 'package:flutter/material.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/models/user.dart';
import 'package:template01/view_models/cart_view_model.dart';

class DishListView extends StatelessWidget {
  final Dishes dish;
  final Users user;
  final ShoppingCartViewModel shoppingCartViewModel;

  DishListView({
    required this.dish,
    required this.user,
    required this.shoppingCartViewModel,
  });

  @override
  Widget build(BuildContext context) {
    double originalPrice = dish.price;
    double discountedPrice = dish.memberPrice ? originalPrice * 0.8 : originalPrice;

    return Card(
      elevation: 2,
      color: Colors.purple[50], // 使用淡紫色作为卡片的背景颜色
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dish.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      if (dish.imageUrl.isNotEmpty)
                        Opacity(
                          opacity: dish.soldOut ? 0.5 : 1.0, // 如果商品售罄，将图片的透明度设置为0.5，否则为1.0
                          child: Image.network(
                            dish.imageUrl,
                            width: 200,
                            height: 2000,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Text(
                        'Description: ${dish.description}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (dish.imageUrl.isNotEmpty)
                ColorFiltered(
                  colorFilter: dish.soldOut
                      ? ColorFilter.mode(Colors.grey, BlendMode.saturation)
                      : ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                  child: Image.network(
                    dish.imageUrl,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Icon(Icons.fastfood, size: 100),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Original Price: \$${originalPrice.toStringAsFixed(1)}',
                      style: TextStyle(
                        decoration: dish.memberPrice ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (dish.memberPrice)
                      Text(
                        'Discounted Price: \$${discountedPrice.toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.green),
                      ),
                    Text('Sales: ${dish.salesVolume}'),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.deepPurple),
                onPressed: dish.soldOut
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('This item is sold out!'),
                      backgroundColor: Colors.red,
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                }
                    : () => shoppingCartViewModel.addToCart(context, dish, user),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

