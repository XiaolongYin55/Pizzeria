import 'package:flutter/material.dart';
import 'package:template01/authentication/AuthService.dart';
import 'package:template01/authentication/login.dart';
import 'package:template01/components/home_carrousel_links.dart';
import 'package:template01/models/user.dart';
import 'package:template01/components/cstm_drawer.dart';
// import 'package:template01/services/firestore.dart';
import 'package:template01/view_models/cart_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerHome extends StatefulWidget {
  final Users user;
  const CustomerHome({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  final AuthService authService = AuthService();
  // final FirestoreService _firestoreService = FirestoreService();
  final ShoppingCartViewModel _shoppingCartViewModel = ShoppingCartViewModel();

  Users? guestUser;

  void signOutGuest() async {
    if (widget.user.role == 'GUEST') {
      print('Signing out guest user: ${widget.user.username}');
      await _shoppingCartViewModel.clearUserCart(widget.user.username);
      await authService.signOutGuest(widget.user.username);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _showPizzaDetails(
      String pizzaName, String description, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pizzaName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath),
              SizedBox(height: 10),
              Text(description),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.orange);
        } else if (index == fullStars && halfStar) {
          return Icon(Icons.star_half, color: Colors.orange);
        } else {
          return Icon(Icons.star_border, color: Colors.orange);
        }
      }),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.9;
    double cardHeight = 200;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white), // 设置图标的颜色为白色
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Center(child: Text('Home')),
        backgroundColor: Colors.black,
        toolbarHeight: 80,
        titleTextStyle:
            TextStyle(color: Colors.white, fontSize: 30), // 设置标题的颜色为白色，字体大小为30
        actionsIconTheme: IconThemeData(color: Colors.white), // 设置图标的颜色为白色
      ),
      drawer: CustomDrawer(user: widget.user, onSignOutGuest: signOutGuest),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome to PIZZARIA ！',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            CarouselAndSocialLinks(
              images: [
                'lib/images/table.jpg',
                'lib/images/kitchen.png',
                'lib/images/cooker.jpeg',
                'lib/images/service.jpeg',
                'lib/images/plate.jpg'
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Discover our delicious range of pizzas, each crafted with care and the freshest ingredients. Our pizza is always with you. Enjoy it',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // 修改描述的颜色
                fontWeight: FontWeight.bold, // 加粗文本
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showPizzaDetails(
                'Seafood Pizza',
                'Delicious seafood pizza with cheese, topped with fresh shrimp, calamari, and scallops.',
                'lib/images/seafood.jpeg',
              ),
              child: Card(
                color: Colors.purple[50], // 设置卡片颜色为淡紫色
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'lib/images/seafood.jpeg',
                      width: cardWidth,
                      height: cardHeight,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Seafood Pizza',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStarRating(4.5),
                          Text(
                            'Delicious seafood pizza with cheese',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showPizzaDetails(
                'Durian Pizza',
                'Unique durian pizza with a blend of sweet and savory flavors.!',
                'lib/images/durain.jpeg',
              ),
              child: Card(
                color: Colors.purple[50], // 设置卡片颜色为淡紫色
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'lib/images/durain.jpeg',
                      width: cardWidth,
                      height: cardHeight,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Durian Pizza',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStarRating(4.5),
                          Text(
                            'Unique durian pizza with a blend of sweet and savory flavors.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showPizzaDetails(
                'Pine Meat Pizza',
                'Savory pizza topped with pineapple and various meats.',
                'lib/images/Pine meat.jpeg',
              ),
              child: Card(
                color: Colors.purple[50], // 设置卡片颜色为淡紫色
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'lib/images/Pine meat.jpeg',
                      width: cardWidth,
                      height: cardHeight,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Pine Meat Pizza',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStarRating(4.0),
                          Text(
                            'Savory pizza topped with pineapple and various meats.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showPizzaDetails(
                'Black Pepper Beef Pizza',
                'Spicy pizza topped with black pepper beef and fresh vegetables.',
                'lib/images/black pepper beef.jpeg',
              ),
              child: Card(
                color: Colors.purple[50], // 设置卡片颜色为淡紫色
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'lib/images/black pepper beef.jpeg',
                      width: cardWidth,
                      height: cardHeight,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Black Pepper Beef Pizza',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStarRating(5.0),
                          Text(
                            'Spicy pizza topped with black pepper beef and fresh vegetables.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.facebook),
              onPressed: () {
                ('https://www.facebook.com');
              },
            ),
            IconButton(
              icon: Icon(Icons.link),
              onPressed: () {
                ('https://www.twitter.com');
              },
            ),
          ],
        ),
      ),
    );
  }
}
