import 'package:flutter/material.dart';
import 'package:template01/authentication/login.dart';
import 'package:template01/authentication/AuthService.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final AuthService authService = AuthService(); // 实例化 AuthService

  final emailController = TextEditingController();
  String? errorMessage;

void confirm() {
  String inputEmail = emailController.text;

  authService.sendPasswordResetEmail(inputEmail).then((_) {
    // 显示一个消息告诉用户密码重置邮件已发送
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset email has been sent.')),
    );

    // 导航到登录页面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }).catchError((error) {
    setState(() {
      errorMessage = 'Failed to send password reset email: $error';
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forget Password',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/images/pizza.png',
                        height: 200,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Text
                  const Text(
                    'Retrieve Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email TextField
                  TextField(
                    controller: emailController,
                    // decoration: InputDecoration(
                    //   hintText: 'xiaolong@graduate.utm.my',
                    // ),
                  ),
                  const SizedBox(height: 20),
                  // Confirm Button
                  ElevatedButton(
                    onPressed: confirm,
                    child: Text('Confirm'),
                  ),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
