import 'package:chatapp_supabase/constants/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.text, this.ontap});
  String? text;
  VoidCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kSecondColor,
        ),
        width: 300,
        height: 50,
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
                color: kForthColor,
                fontFamily: "Playwrite",
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ),
      ),
    );
  }
}
