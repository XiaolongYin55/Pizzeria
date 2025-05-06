import 'package:flutter/material.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/services/firestore.dart';

class DishesViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Dishes> _dishes = [];
  bool _isLoading = false;
//~ ------------ getDishes method in vew model ---------------------
  List<Dishes> get dishes => _dishes;
  bool get isLoading => _isLoading;
  Stream<List<Dishes>> get dishesStream => _firestoreService.getDishes();
  DishesViewModel() {
    fetchDishes();
  }

  void fetchDishes() {
    _isLoading = true;
    notifyListeners();

    _firestoreService.getDishes().listen((dishesData) {
      _dishes = dishesData;
      _isLoading = false;
      notifyListeners();
    });
  }
//~ ------------ Get dishes by name ------------------------------  
    Future<Dishes?> getDishByName(String name) async {
    return await _firestoreService.getDishByName(name);
  }
//~ ------------ Insert dishes in view model ----------------------
Future<void> addDish(Dishes dish) async {
  await _firestoreService.addDish(dish);
  fetchDishes();
  notifyListeners();
}
//~ ------------ Delete dishes in view model ---------------------
  Future<void> deleteDish(String id) async {
    await _firestoreService.deleteDish(id);
    fetchDishes(); // 更新菜品列表
    notifyListeners(); // 通知 View 层数据的变化
  }

//~ ------------ Update dishes in view model ---------------------
Future<void> updateDish(Dishes dish) async {
  await _firestoreService.updateDish(dish);
  fetchDishes();
  notifyListeners();
}
}