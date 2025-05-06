import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText; // 新添加的按钮文本参数

  const MyButton({Key? key, required this.onTap, this.buttonText = 'Sign In'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromARGB(214, 0, 0, 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            buttonText, // 使用 buttonText 参数作为按钮文本
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
