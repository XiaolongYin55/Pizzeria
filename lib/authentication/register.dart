import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:template01/authentication/AuthService.dart';
import 'package:template01/authentication/login.dart';
import 'package:template01/paragraph/my_textfield.dart';
import 'package:template01/paragraph/my_button.dart';
import 'package:template01/models/user.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? errorMessage;

  //text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  void registerPage() {
    String inputUsername = usernameController.text;
    String inputPassword = passwordController.text;
    String inputPhone = phoneNumberController.text;
    String inputEmail = emailController.text;
    AuthService authService = AuthService();

    authService.isUsernameTaken(inputUsername).then((usernameIsTaken) {
      if (usernameIsTaken) {
        setState(() {
          errorMessage = '用户名已经被使用，请选择其他用户名';
        });
      } else {
        authService.isEmailTaken(inputEmail).then((emailIsTaken) {
          if (emailIsTaken) {
            setState(() {
              errorMessage = '电子邮件地址已经被其他账户使用，请选择其他电子邮件地址';
            });
          } else {
            authService
                .registerUser(Users(
              username: inputUsername,
              password: inputPassword,
              phone: inputPhone,
              email: inputEmail,
              role: 'CUSTOMER',
              createDate: DateTime.now(),
              updateDate: DateTime.now(),
            ))
                .then((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }).catchError((error) {
              setState(() {
                if (error is FirebaseAuthException && error.code == 'email-already-in-use') {
                  errorMessage = '电子邮件地址已经被其他账户使用';
                } else {
                  errorMessage = '注册失败: $error';
                }
              });
            });
          }
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                //logo

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/pizza.png',
                      height: 200,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                //welcome
                Text(
                  'Welcome to join us',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(
                  height: 50,
                ),
                //username
                MyTextfield(
                  controller: usernameController,
                  hintText: ' username',
                  obscureText: false,
                ),

                const SizedBox(
                  height: 10,
                ),

                //password
                MyTextfield(
                  controller: passwordController,
                  hintText: ' password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                //email
                MyTextfield(
                  controller: emailController,
                  hintText: ' email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //phone
                MyTextfield(
                  controller: phoneNumberController,
                  hintText: ' phone',
                  obscureText: false,
                ),
                const SizedBox(height: 50),
                //sign in
                MyButton(
                  buttonText: 'Sign Up',
                  onTap: () {
                    registerPage(); // 调用注册逻辑
                  },
                ),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have account?'),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign in now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const SizedBox(height: 10),

                const SizedBox(height: 50),

                //continue with google
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
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
