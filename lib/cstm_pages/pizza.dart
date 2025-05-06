import 'package:flutter/material.dart';
import 'package:template01/components/cstm_cart_bar.dart';
import 'package:template01/components/cstm_size_dialog.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
// import 'package:template01/services/firestore.dart';
import 'package:template01/view_models/cart_view_model.dart';
import 'package:template01/view_models/dish_view_model.dart';

class PizzaPage extends StatefulWidget {
  final Users user;

  const PizzaPage({Key? key, required this.user}) : super(key: key);

  @override
  State<PizzaPage> createState() => _PizzaPageState();
}

class _PizzaPageState extends State<PizzaPage> {
  // final FirestoreService firestoreService = FirestoreService();
  final DishesViewModel _dishesViewModel = DishesViewModel();
  late ShoppingCartViewModel _shoppingCartViewModel;
  List<ShoppingCartItem> shoppingCartItems = [];

  @override
  void initState() {
    super.initState();
    _shoppingCartViewModel = ShoppingCartViewModel(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pizza Page'),
        backgroundColor: Colors.deepPurple[200],
        toolbarHeight: 80,
      ),
      body: StreamBuilder<List<Dishes>>(
        stream: _dishesViewModel.dishesStream,
        builder: (BuildContext context, AsyncSnapshot<List<Dishes>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dishes = snapshot.data!.where((dish) => dish.type == 'pizza').toList();
            return ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (BuildContext context, int index) {
                final dish = dishes[index];
                double originalPrice = dish.price;
                double discountedPrice = dish.memberPrice ? originalPrice * 0.8 : originalPrice;

                return Card(
                  color: Colors.deepPurple[50],
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(right: 16.0),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: dish.imageUrl.isNotEmpty
                                  ? ColorFiltered(
                                      colorFilter: dish.soldOut
                                          ? ColorFilter.mode(Colors.grey, BlendMode.saturation)
                                          : ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                                      child: Image.network(
                                        dish.imageUrl,
                                        width: 70, // 修改图片的宽度
                                        height: 70, // 修改图片的高度
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.fastfood, size: 70), // 修改图标的大小
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(dish.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text('Original Price: \$${originalPrice.toStringAsFixed(1)}', style: TextStyle(decoration: dish.memberPrice ? TextDecoration.lineThrough : null)),
                              if (dish.memberPrice) Text('Discounted Price: \$${discountedPrice.toStringAsFixed(1)}', style: TextStyle(color: Colors.green)),
                              Text('Sales: ${dish.salesVolume}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: dish.soldOut
                        ? IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.deepPurple),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('This item is sold out!'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            },
                          )
                        : SizeDialog(
                            dish: dish,
                            user: widget.user,
                            dishesViewModel: _dishesViewModel,
                            shoppingCartViewModel: _shoppingCartViewModel,
                          ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: ShoppingCartBar(
        shoppingCartViewModel: _shoppingCartViewModel,
        user: widget.user,
      ),
    );
  }
}
