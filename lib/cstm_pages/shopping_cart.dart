import 'package:flutter/material.dart';
import 'package:template01/cstm_pages/payment_page.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
// import 'package:template01/services/firestore.dart';
import 'package:template01/view_models/cart_view_model.dart';

class ShoppingCartPage extends StatefulWidget {
  final List<ShoppingCartItem> shoppingCartItems;
  final double totalPrice;
  final Users user;

  const ShoppingCartPage({
    Key? key,
    required this.shoppingCartItems,
    required this.totalPrice,
    required this.user,
  }) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  late ShoppingCartViewModel _shoppingCartViewModel = ShoppingCartViewModel();

  // @override
  // void initState() {
  //   super.initState();
  //   _shoppingCartViewModel = ShoppingCartViewModel(widget.user);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.deepPurple[200],
        toolbarHeight: 80,
        // Set the app bar color to purple
      ),
      body: StreamBuilder(
        stream: _shoppingCartViewModel.getShoppingCartItems(widget.user.username),
        builder: (BuildContext context, AsyncSnapshot<List<ShoppingCartItem>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final shoppingCartItems = snapshot.data!;
            double totalPrice = shoppingCartItems.fold(0, (sum, item) => sum + item.total);
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: shoppingCartItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final items = shoppingCartItems[index];
                      return Card(
                        color: Colors.purple[50],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: items.imageUrl.isNotEmpty
                                    ? Image.network(
                                  items.imageUrl,
                                  fit: BoxFit.contain,
                                )
                                    : Icon(Icons.fastfood, size: 100.0),
                              ),
                              Expanded(
                                flex: 3,
                                child: ListTile(
                                  title: Text(items.name),
                                  subtitle: Text(
                                    'Type: ${items.type}, Price: ${items.total.toStringAsFixed(1)}, Quantity: ${items.quantity}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () async {
                                          if (items.quantity > 0) {
                                            items.quantity--;
                                            items.total = items.price * items.quantity;
                                            await _shoppingCartViewModel.updateCartItem(items);
                                          }
                                          if (items.quantity == 0) {
                                            await _shoppingCartViewModel.deleteCartItem(items.id);
                                          }
                                        },
                                      ),
                                      Text('${items.quantity}'),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () async {
                                          items.quantity++;
                                          items.total = items.price * items.quantity;
                                          await _shoppingCartViewModel.updateCartItem(items);
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Handle dish tile tap if needed
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$${totalPrice.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Add padding to the button
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 18), // Increase font size
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          shoppingCartItems: shoppingCartItems,
                          totalPrice: totalPrice,
                          user: widget.user,
                          shoppingCartViewModel: _shoppingCartViewModel,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}