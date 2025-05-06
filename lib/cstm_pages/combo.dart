import 'package:flutter/material.dart';
import 'package:template01/components/cstm_cart_bar.dart';
import 'package:template01/components/cstm_dish_list_view.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
import 'package:template01/view_models/cart_view_model.dart';
import 'package:template01/view_models/dish_view_model.dart';

class ComboPage extends StatefulWidget {
  final Users user;
  const ComboPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ComboPage> createState() => _ComboPageState();
}

class _ComboPageState extends State<ComboPage> {
  // final FirestoreService firestoreService = FirestoreService();
  final DishesViewModel _dishesViewModel = DishesViewModel();
  late ShoppingCartViewModel _shoppingCartViewModel = ShoppingCartViewModel();
  List<ShoppingCartItem> shoppingCartItems = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _shoppingCartViewModel = ShoppingCartViewModel(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combo Page'),
        backgroundColor: Colors.deepPurple[200],
        toolbarHeight: 80,
      ),
      body: StreamBuilder(
        //~ get dish list by dish view model
        stream: _dishesViewModel.dishesStream,
        builder: (BuildContext context, AsyncSnapshot<List<Dishes>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            //~ filter dish by type
            final dishes = snapshot.data!
                .where((dish) =>
                    dish.type == 'one-person' || dish.type == 'multi-person')
                .toList();
            return ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (BuildContext context, int index) {
                final dish = dishes[index];
                //~ display filtered dishes on dish_list_view page
                return DishListView(
                    dish: dish,
                    user: widget.user,
                    shoppingCartViewModel: _shoppingCartViewModel,);
              },
            );
          }
        },
      ),
      //~ shopping cart area
      bottomNavigationBar: ShoppingCartBar(
        shoppingCartViewModel: _shoppingCartViewModel,
        user: widget.user,
      ),
    );
  }
}
