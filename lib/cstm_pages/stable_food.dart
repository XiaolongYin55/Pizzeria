import 'package:flutter/material.dart';
import 'package:template01/components/cstm_cart_bar.dart';
import 'package:template01/components/cstm_dish_list_view.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
import 'package:template01/view_models/cart_view_model.dart';
import 'package:template01/view_models/dish_view_model.dart';

class StableFoodPage extends StatefulWidget {
  const StableFoodPage({Key? key, required this.user}) : super(key: key);
  final Users user;
  @override
  State<StableFoodPage> createState() => _StableFoodPageState();
}

class _StableFoodPageState extends State<StableFoodPage> {
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
        title: Text('Stable Food'),
        backgroundColor: Colors.deepPurple[200],
        toolbarHeight: 80,
      ),
      body: StreamBuilder(
        stream: _dishesViewModel.dishesStream,
        builder: (BuildContext context, AsyncSnapshot<List<Dishes>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dishes = snapshot.data!
                .where((dish) =>
                    dish.type == 'rice' ||
                    dish.type == 'pasta' ||
                    dish.type == 'bread' ||
                    dish.type == 'dessert' ||
                    dish.type == 'steak')
                .toList();
            return ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (BuildContext context, int index) {
                final dish = dishes[index];
                return DishListView(
                    dish: dish,
                    user: widget.user,
                    shoppingCartViewModel: _shoppingCartViewModel);
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
