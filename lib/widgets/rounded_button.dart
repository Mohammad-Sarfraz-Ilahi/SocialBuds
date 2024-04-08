import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String btnText;
  final Function() onBtnPressed;

  const RoundedButton(
      {super.key, required this.btnText, required this.onBtnPressed,});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Color.fromARGB(255, 255, 78, 90),
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(onPressed: onBtnPressed,
      minWidth: 320,
        height: 60,
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),),
    );
  }
}
