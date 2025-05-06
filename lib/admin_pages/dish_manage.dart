import 'package:flutter/material.dart';
import 'package:template01/components/admin_open_dish_box.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/models/user.dart';
import 'package:template01/view_models/dish_view_model.dart';

// import 'package:template01/open_dish_box.dart'; // 确保你已经导入了 open_dish_box.dart 文件s
class DishManage extends StatefulWidget {
  final Users? user;

  const DishManage({Key? key, this.user}) : super(key: key);

  @override
  _DishManageState createState() => _DishManageState();
}

class _DishManageState extends State<DishManage> {
  // final FirestoreService firestoreService = FirestoreService();
  final DishesViewModel _dishesViewModel = DishesViewModel();
  final OpenDishBox openDishBox = OpenDishBox();

  String? _selectedMenuItem; // 用于存储选中的菜单项

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Center(child: Text('Dishes')),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              _showMenuOptions(context);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        //~ get dishes by dish VM
        stream: _dishesViewModel.dishesStream,
        builder: (BuildContext context, AsyncSnapshot<List<Dishes>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dishes = snapshot.data!;
            if (_selectedMenuItem == 'sales') {
              dishes.sort((a, b) => b.salesVolume.compareTo(a.salesVolume));
            }
            return ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (BuildContext context, int index) {
                final dish = dishes[index];
                if (_selectedMenuItem != null) {
                  if (_selectedMenuItem == 'combo' &&
                      (dish.type != 'one-person' &&
                          dish.type != 'multi-person')) {
                    return SizedBox.shrink();
                  }
                  if (_selectedMenuItem == 'stable food' &&
                      !(dish.type == 'rice' ||
                          dish.type == 'pasta' ||
                          dish.type == 'bread' ||
                          dish.type == 'dessert' ||
                          dish.type == 'steak')) {
                    return SizedBox.shrink();
                  }
                  if (_selectedMenuItem == 'drink' &&
                      (dish.type != 'soup' && dish.type != 'beverage')) {
                    return SizedBox.shrink();
                  }
                  if (_selectedMenuItem == 'pizza' && dish.type != 'pizza') {
                    return SizedBox.shrink();
                  }
                  if (_selectedMenuItem == 'snack' && dish.type != 'snack') {
                    return SizedBox.shrink();
                  }
                }
                return Card(
                  elevation: 2,
                  color: Colors.purple[50],
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        dish.imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  dish.imageUrl,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.fastfood, size: 50),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dish.name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('Type: ${dish.type}',
                                  style: TextStyle(fontSize: 16)),
                              Text('Price: ${dish.price}',
                                  style: TextStyle(fontSize: 16)),
                              Text('Quantity: ${dish.quantity}',
                                  style: TextStyle(fontSize: 16)),
                              Text('Sales: ${dish.salesVolume}',
                                  style: TextStyle(fontSize: 16)),
                              Text('Sold out: ${dish.soldOut}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.deepPurple),
                          onPressed: () {
                            openDishBox.triggerOpenDishBox(context, dish: dish);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            print('Dish id is: ' + dish.id);
                            //~ delete dish by dish VM
                            await _dishesViewModel.deleteDish(dish.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Deleted dish with ID: ${dish.id}')),
                            );
                            setState(() {}); // 触发状态更新
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDishBox.triggerOpenDishBox(context);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showMenuOptions(BuildContext context) {
    final List<String> menuItems = [
      'pizza',
      'snack',
      'combo',
      'stable food',
      'drink',
      'sales'
    ];
    final List<PopupMenuItem<String>> popupMenuItems =
        menuItems.map((String item) {
      return PopupMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 60.0, 0, 0),
      items: popupMenuItems,
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedMenuItem = value;
        });
      }
    });
  }
}
