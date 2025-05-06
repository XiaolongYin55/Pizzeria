import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Dishes {
  String id; // Your defined ID attribute
  String name;
  String description;
  String image;
  String imageUrl;
  double price;
  int quantity;
  int size;
  String type;
  bool memberPrice;
  Timestamp createDate;
  Timestamp updateDate;
  int salesVolume; // 新增的销量属性
  bool soldOut; // 新增的销售状态属性

  // Constructor
  Dishes({
    required this.id, // Modify constructor to accept id parameter
    required this.name,
    required this.description,
    required this.image,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.size,
    required this.type,
    required this.memberPrice,
    required this.createDate,
    required this.updateDate,
    required this.salesVolume, // 在构造函数中添加销量参数
    required this.soldOut, // 在构造函数中添加销售状态参数
  });

  // Factory constructor to create a Dish object from a Firebase document snapshot
  factory Dishes.fromMap(Map<String, dynamic> map) {
    return Dishes(
      id: map['id'] ?? Uuid().v1(), // 如果map中没有id，则生成一个新的UUID
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: (map['quantity'] ?? 0).toInt(),
      size: (map['size'] ?? 0).toInt(),
      type: map['type'] ?? '',
      memberPrice: map['memberPrice'] ?? false,
      createDate: map['createDate'] as Timestamp,
      updateDate: map['updateDate'] as Timestamp,
      salesVolume: (map['salesVolume'] ?? 0).toInt(), // 从 Firebase 文档快照中获取销
      soldOut: map['soldOut'] ?? false,
    );
  }

  // 将Dishes对象转换为Map对象的方法
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'size': size,
      'type': type,
      'memberPrice': memberPrice,
      'createDate': createDate,
      'updateDate': updateDate,
      'salesVolume': salesVolume,
      'soldOut': soldOut,
    };
  }
}




