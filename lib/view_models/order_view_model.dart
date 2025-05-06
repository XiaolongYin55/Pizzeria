import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:template01/models/orders.dart';
import 'package:template01/services/firestore.dart';

class OrdersViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Orders> _orders = [];
  bool _isLoading = false;

  List<Orders> get orders => _orders;
  bool get isLoading => _isLoading;

  OrdersViewModel() {
    fetchOrders();
  }

  void fetchOrders() {
    _isLoading = true;
    notifyListeners();

    _firestoreService.getOrders().listen((ordersData) {
      _orders = ordersData;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<DocumentReference> addOrder(Orders order) {
    return _firestoreService.addOrder(order);
  }
  Future<void> createOrder(Orders order) async {
    await _firestoreService.createOrder(order);
  }

  Future<void> deleteOrder(String id) async {
    await _firestoreService.deleteOrder(id);
  }
    Stream<List<Orders>> getOrders() {
    return _firestoreService.getOrders();
  }

  Future<void> updateOrder(Orders order) async {
    await _firestoreService.updateOrder(order);
  }
}