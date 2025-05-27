// ignore_for_file: must_be_immutable

import 'package:chatapp_supabase/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.hinttext,
      this.onChanged,
      this.obscure = false,
      this.icon,
      this.pressed,
      this.hidepassword = false});
  String? hinttext;
  Function(String)? onChanged;
  bool obscure;
  final Icon? icon;
  VoidCallback? pressed;
  bool hidepassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hidepassword,
      validator: (data) {
        if (data!.isEmpty) {
          return "Enter your $hinttext";
        }
      },
      style: TextStyle(color: kSecondColor),
      decoration: InputDecoration(
          label: Text(hinttext!),
          labelStyle: TextStyle(color: kForthColor),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: kForthColor, width: 4)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: kSecondColor, width: 4)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 255, 17, 0), width: 3)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: kSecondColor),
          ),
          suffixIcon: obscure == false
              ? null
              : IconButton(onPressed: pressed, icon: icon!)),
      onChanged: onChanged,
    );
  }
}
