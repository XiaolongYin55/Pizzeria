import 'package:flutter/material.dart';
import 'package:template01/paragraph/my_textfield.dart';
import 'package:template01/paragraph/my_button.dart';
import 'package:template01/models/user.dart';

class ResetPasswordPage extends StatefulWidget {
  final Users user;

  const ResetPasswordPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage;

  void resetPassword() {
    String inputNewPassword = newPasswordController.text;
    String inputConfirmPassword = confirmPasswordController.text;

    if (inputNewPassword == inputConfirmPassword) {
      widget.user.password = inputNewPassword;
      Navigator.pushNamed(context, '/loginPage');
    } else {
      setState(() {
        errorMessage = 'Two passwords do not match';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
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
                'Reset Password',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // New Password TextField
              MyTextfield(
                controller: newPasswordController,
                hintText: 'New password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              // Confirm Password TextField
              MyTextfield(
                controller: confirmPasswordController,
                hintText: 'Confirm password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Confirm Button
              MyButton(
                buttonText: 'Confirm',
                onTap: resetPassword,
              ),

              // ...
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
