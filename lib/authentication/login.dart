import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:template01/admin_pages/admin_page.dart';
import 'package:template01/authentication/AuthService.dart';
import 'package:template01/authentication/register.dart';
import 'package:template01/components/dish_controllers.dart';
import 'package:template01/cstm_pages/cstm_home.dart';
import 'package:template01/authentication/forget_password.dart';
import 'package:template01/paragraph/my_textfield.dart';
import 'package:template01/paragraph/my_button.dart';
import 'package:template01/models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService(); // 实例化 AuthService
  final MyController _myCtrls = MyController();
  String errorMessage = '';
  Users? guestUser;
  void signUserIn() async {
    String username = _myCtrls.usernameController.text;
    String password = _myCtrls.passwordController.text;

    try {
      // Get the email associated with the username
      Users? user = await authService.getUser(username);
      if (user != null) {
        // Sign in with Firebase Authentication
        // ignore: unused_local_variable
        UserCredential userCredential =
            await authService.auth.signInWithEmailAndPassword(
          email: user.email,
          password: password,
        );

        if (user.role == 'ADMIN') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminHome(user: user)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerHome(user: user)),
          );
        }
      } else {
        setState(() {
          errorMessage = 'Account does not exist, please register an account';
        });
      }
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      setState(() {
        errorMessage = 'Failed to sign in: ${e.message}';
      });
    }
  }

  void signInAsGuest() async {
    // 生成一个唯一的 "guest" 用户名
    String guestUsername = 'Guest${Random().nextInt(100000)}';

    // 创建一个新的 "guest" 用户
    Users user = Users(
      username: guestUsername,
      password: '123',
      phone: '',
      email: '',
      role: 'GUEST',
      createDate: DateTime.now(),
      updateDate: DateTime.now(),
    );

    // 将 "guest" 用户添加到 Firestore 数据库中
    await authService.usersRef.doc(guestUsername).set({
      'username': user.username,
      'password': user.password,
      'phone': user.phone,
      'email': user.email,
      'role': user.role,
      'createDate': user.createDate,
      'updateDate': user.updateDate,
    });

    // 导航到 CustomerHome 页面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerHome(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/pizza.png',
                      height: 200,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome to pizzeria',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 50),
                MyTextfield(
                  controller: _myCtrls.usernameController,
                  hintText: 'username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: _myCtrls.passwordController,
                  hintText: 'password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Forget password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                MyButton(
                  buttonText: "Sign In",
                  onTap: signUserIn,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign up now",
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: signInAsGuest, // 修改这一行
                      child: const Text(
                        "Sign in as a guest",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/Google.png',
                      height: 72,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
