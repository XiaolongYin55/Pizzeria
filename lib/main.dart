// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:template01/firebase_options.dart';
// import 'package:template01/models/cart_model.dart';
import 'package:template01/authentication/login.dart';
import 'package:provider/provider.dart';
// import 'package:template01/models/user.dart';
import 'package:template01/view_models/cart_view_model.dart';
import 'package:template01/view_models/dish_view_model.dart';
import 'package:template01/view_models/order_view_model.dart';
import 'package:template01/view_models/user_view_model.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    print('Firebase connected successfully!');
  }).catchError((error) {
    print('Failed to connect to Firebase: $error');
  });


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShoppingCartViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => DishesViewModel()),
        ChangeNotifierProvider(create: (context) => OrdersViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      //for now directly go to customers page
      home:LoginPage(),
    );
  }
}
