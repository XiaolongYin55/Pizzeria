// import 'package:cloud_firestore/cloud_firestore.dart';
class ShoppingCartItem {
  late String id; // Your defined ID attribute
  late String imageUrl;
  late String name;
  late double price;
  late int quantity;
  late double total;
  late String type;
  late String username;

  // Constructor
  ShoppingCartItem({
    required this.id, // Modify constructor to accept id parameter
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
    required this.type,
    required this.username,
  });

  // Factory constructor to create a ShoppingCartItem object from a Firebase document snapshot
  factory ShoppingCartItem.fromMap(Map<String, dynamic> map) {
    return ShoppingCartItem(
      id: map['id'],
      imageUrl: map['imageUrl'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: (map['quantity'] ?? 0).toInt(),
      total: (map['totalPrice'] ?? 0.0).toDouble(),
      type: map['type'] ?? '',
      username: map['username'] ?? '',
    );
  }
}
