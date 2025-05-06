import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template01/components/admin_open_order_box.dart';
import 'package:template01/models/orders.dart';
import 'package:template01/view_models/order_view_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // final FirestoreService firestoreService = FirestoreService();
  final OrdersViewModel _ordersViewModel = OrdersViewModel();
  final OpenOrderBox openOrderBox = OpenOrderBox();
  DateTime? startDate;
  DateTime? endDate;
  String? searchUsername; // 用于存储搜索的用户名
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Orders')),
        backgroundColor: Colors.deepPurple[200],
        actions: [
          IconButton(
            icon: Icon(Icons.date_range, color: Colors.black),
            onPressed: () async {
              startDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              endDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              setState(
                  () {}); // Trigger a state update to refresh the order list
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Search by username'),
                    content: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(hintText: "Enter username"),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Search'),
                        onPressed: () {
                          setState(() {
                            searchUsername = _searchController.text;
                          });
                          _searchController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          _searchController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        //~ get orders by VM
        stream: _ordersViewModel.getOrders(),
        builder: (BuildContext context, AsyncSnapshot<List<Orders>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final startDateTime = startDate != null
                ? DateTime(
                    startDate!.year, startDate!.month, startDate!.day, 0, 0, 0)
                : null;
            final endDateTime = endDate != null
                ? DateTime(
                    endDate!.year, endDate!.month, endDate!.day, 23, 59, 59)
                : null;
            final orders = snapshot.data!.where((order) {
              if (searchUsername != null && order.username != searchUsername) {
                return false;
              }
              if (startDateTime != null && endDateTime != null) {
                return (order.createDate.isAtSameMomentAs(startDateTime) ||
                        order.createDate.isAfter(startDateTime)) &&
                    (order.createDate.isAtSameMomentAs(endDateTime) ||
                        order.createDate.isBefore(endDateTime));
              } else if (startDateTime != null) {
                return order.createDate.isAtSameMomentAs(startDateTime) ||
                    order.createDate.isAfter(startDateTime);
              } else if (endDateTime != null) {
                return order.createDate.isAtSameMomentAs(endDateTime) ||
                    order.createDate.isBefore(endDateTime);
              } else {
                return true;
              }
            }).toList();
//^---------------- decoration ----------------------------------
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.all(8.0), // 为每个订单添加边距，从而分隔开
                  elevation: 4.0, // 添加阴影效果
                  child: ExpansionTile(
                    title: Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(order.createDate),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18), // 加大并加粗字体
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CUSTOMER: ${order.username}',
                          style: TextStyle(fontSize: 16), // 设置字体大小
                        ),
                        Text(
                          'TOTAL: \$${order.total.toStringAsFixed(1)}',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple), // 设置字体大小和颜色
                        ),
                      ],
                    ),
                    children: order.dishes.map((dish) {
                      double totalPrice = dish['quantity'] * dish['price'];
                      return ListTile(
                        title: Text(
                          'Item: ${dish['name']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16), // 加粗并调整字体大小
                        ),
                        subtitle: Text(
                          '${dish['quantity']} x ${dish['price'].toStringAsFixed(1)} \nAmount: \$${totalPrice.toStringAsFixed(1)}',
                          style: TextStyle(fontSize: 15), // 调整字体大小
                        ),
                      );
                    }).toList(),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.deepPurple),
                          onPressed: () {
                            openOrderBox.triggerOpenOrderBox(context,
                                order: order);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            print('Order id is: ' + order.id);
                            //~delete order by VM
                            await _ordersViewModel.deleteOrder(order.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Deleted order with ID: ${order.id}')),
                            );
                            setState(() {}); // Trigger a state update
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
          openOrderBox.triggerOpenOrderBox(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
