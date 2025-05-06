import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  late String id;
  final String username;
  final double total;
  final List<Map<String, dynamic>> dishes;
  final DateTime createDate;
  final DateTime updateDate;

  Orders({
    required this.id,
    required this.username,
    required this.total,
    required this.dishes,
    required this.createDate,
    required this.updateDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'total': total,
      'dishes': dishes,
      'create_date': Timestamp.fromDate(createDate),
      'update_date': Timestamp.fromDate(updateDate),
    };
  }

//! new map
  Map<String, dynamic> toMapWithoutDishes() {
    return {
      'id': id,
      'username': username,
      'total': total,
      'create_date': Timestamp.fromDate(createDate),
      'update_date': Timestamp.fromDate(updateDate),
    };
  }

  factory Orders.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Orders(
      id: doc.id,
      username: map['username'] ?? '',
      total: (map['total'] ?? 0.0).toDouble(),
      dishes: (map['dishes'] as List<dynamic>).cast<Map<String, dynamic>>(),
      createDate: (map['create_date'] as Timestamp).toDate(),
      updateDate: (map['update_date'] as Timestamp).toDate(),
    );
  }
}
