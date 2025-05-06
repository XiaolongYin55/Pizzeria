import 'package:flutter/material.dart';
import 'package:template01/cstm_pages/combo.dart';
import 'package:template01/cstm_pages/pizza.dart';
import 'package:template01/cstm_pages/snack.dart';
import 'package:template01/cstm_pages/drinks.dart';
import 'package:template01/cstm_pages/stable_food.dart';
import 'package:template01/models/user.dart';
import 'package:template01/pages/my_profile.dart';
import 'package:url_launcher/url_launcher.dart'; // 导入 url_launcher 库

class CustomDrawer extends StatelessWidget {
  final Users user;
  final VoidCallback onSignOutGuest;
  const CustomDrawer({
    Key? key,
    required this.user,
    required this.onSignOutGuest,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        padding: EdgeInsets.only(top: 20), // 设置顶部间距为 20 像素
        children: <Widget>[
          Container(
            height: 300,        // 设置DrawerHeader和ListTile之间的空间距离
            child:DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFF7F6FA), // Adjust the color as needed
              ),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/PIZZAA.png',            //插入PIZZAA的图标
                      height: 150,
                    ),

                    SizedBox(height: 16), // Add some space between the image and the text
                    Text(
                      'PIZZARIA',                         //在PIZZAA图标的下面加text
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
            leading: Icon(Icons.person, size: 42),
            title: Text('Profile', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyProfilePage(user: user)));
            },
          ),
          Divider(),  //分割线

          ListTile(
            leading: Icon(Icons.fastfood, size: 42),
            title: Text('Combo', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ComboPage(user: user)));
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.local_pizza, size: 42),
            title: Text('Pizza', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PizzaPage(user: user)));
            },
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.local_dining, size: 42),
            title: Text('Snack', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SnackPage(user: user)));
            },
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.soup_kitchen, size: 42),
            title: Text('Drinks', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Drinks(user: user)));
            },
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.restaurant, size: 42),
            title: Text('Stable Food', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StableFoodPage(user: user)));
            },
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.logout, size: 42),
            title: Text("Logout", style: TextStyle(fontSize: 18)),
            onTap: onSignOutGuest,
          ),
          Divider(),
          SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.link),
                onPressed: () {
                  launch('https://twitter.com'); // 打开 Twitter 网站链接
                },
              ),
              IconButton(
                icon: Icon(Icons.facebook),
                onPressed: () {
                  launch('https://facebook.com'); // 打开 Facebook 网站链接
                },
              ),
              IconButton(
                icon: Icon(Icons.link),
                onPressed: () {
                  launch('https://www.google.com'); // 打开 Google 网站链接
                },
              ),
              IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {
                  launch('https://web.whatsapp.com'); // 打开 WhatsApp 网站链接
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
