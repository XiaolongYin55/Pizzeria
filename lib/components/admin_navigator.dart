import 'package:flutter/material.dart';
import 'package:template01/admin_pages/order_page.dart';
import 'package:template01/pages/contact_us.dart';
import 'package:template01/authentication/login.dart';
import 'package:template01/pages/my_profile.dart';
import 'package:template01/models/user.dart';
import 'package:template01/admin_pages/dish_manage.dart';
import 'package:template01/admin_pages/admin_page.dart';

class AdminPageCom extends StatelessWidget {
  final Users user;

  const AdminPageCom({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        padding: EdgeInsets.only(top: 20),
        children: <Widget>[
          Container(
            height: 300,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFF7F6FA), // Adjust the color as needed
              ),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/PIZZAA.png',
                      height: 150,
                    ),

                    SizedBox(
                        height:
                            16), // Add some space between the image and the text
                    Text(
                      'PIZZARIA',
                      style: TextStyle(
                        fontSize: 24, // Adjust the text size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Adjust the text color as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, size: 42),
            title: Text("HOME", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminHome(user: user)),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person, size: 42),
            title: Text("Company Profile", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyProfilePage(key: UniqueKey(), user: user)),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone, size: 42),
            title: Text("CONTACT US", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ContactUsPage(key: UniqueKey(), user: user)),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.restaurant_menu, size: 42),
            title: Text("Dish Manage", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DishManage(key: UniqueKey(), user: user)),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.receipt, size: 42),
            title: Text("Orders", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderPage(
                          key: UniqueKey(),
                        )),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, size: 42),
            title: Text("Logout", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
