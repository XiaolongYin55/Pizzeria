import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';  //直接从flutter添加一个信用卡
// import 'package:template01/cstm_pages/cstm_home.dart';
// import 'package:template01/models/orders.dart';
import 'package:template01/models/shopping_cart.dart';
import 'package:template01/models/user.dart';
import 'package:template01/components/cstm_payment_box.dart';
import 'package:template01/view_models/cart_view_model.dart';
import 'package:template01/view_models/dish_view_model.dart';
import 'package:template01/view_models/order_view_model.dart'; // 导入新文件

// ignore: must_be_immutable
class PaymentPage extends StatelessWidget {
  // final FirestoreService _firestoreService = FirestoreService();
  final DishesViewModel _dishesViewModel = DishesViewModel();
  final OrdersViewModel _ordersViewModel = OrdersViewModel();
  final ShoppingCartViewModel shoppingCartViewModel;
  final List<ShoppingCartItem> shoppingCartItems;
  final double totalPrice;
  final Users user;

  String cardNumber='1234 5678 9012 3456';       //新加的  信用卡的信息
  String expiryDate='10/28';                    //新加的
  String cardHolderName='Paul';                //新加的
  String cvvCode = '123';                     //新加的
  bool isCvvFocused = false;                //新加的

  PaymentPage({
    Key? key,
    required this.shoppingCartItems,
    required this.totalPrice,
    required this.user,
    required this.shoppingCartViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
        backgroundColor: Colors.deepPurple[200],
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0){},
            ),

            _buildTextField(
              label: 'Cardholder Name',
              hintText: 'Paul',
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              label: 'Card Number',
              hintText: '1234 5678 9012 3456',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Expiration Date',
                    hintText: '10/28',
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildTextField(
                    label: 'Security Code',
                    hintText: '123',
                    keyboardType: TextInputType.number,
                    icon: Icons.lock,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                showPaymentSuccessDialog(
                  context: context,
                  dishesViewModel: _dishesViewModel,
                  shoppingCartViewModel: shoppingCartViewModel,
                  // firestoreService: _firestoreService,
                  ordersViewModel: _ordersViewModel,
                  user: user,
                  shoppingCartItems: shoppingCartItems,
                  totalPrice: totalPrice,
                );
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
            suffixIcon: icon != null ? Icon(icon) : null,
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
