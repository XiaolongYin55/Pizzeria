import 'package:flutter/material.dart';
import 'package:template01/admin_pages/admin_page.dart';
// import 'package:template01/admin_pages/home_page.dart';
import 'package:template01/pages/my_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:template01/models/user.dart';

class ContactUsPage extends StatelessWidget {
  final Users user;

  const ContactUsPage({Key? key, required this.user}) : super(key: key);

  // Method to launch URLs
  void _launchURL(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: Column(children: [
          DrawerHeader(child: Icon(Icons.settings_accessibility, size: 60)),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("HOME"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminHome(user: user)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("My Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyProfilePage(key: UniqueKey(), user: user)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("CONTACT US"),
            onTap: () {
              Navigator.pushNamed(context, '/contactUsPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              Navigator.pushNamed(context, '/loginPage');
            },
          )
        ]),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Click button to contact us ~',
              style: TextStyle(color: Colors.grey[700]),
            ),
            IconButton(
              icon: Icon(
                Icons.phone_android,
                size: 40.0,
              ),
              onPressed: () => _launchURL('https://wa.me/+601161220980'),
            ),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(
                Icons.facebook,
                size: 40.0,
              ),
              onPressed: () => _launchURL(
                  'https://www.facebook.com/profile.php?id=100069972000599'),
            ),
          ],
        ),
      ),
    );
  }
}
