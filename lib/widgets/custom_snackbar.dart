import 'package:chatapp_supabase/constants/constants.dart';
import 'package:flutter/material.dart';

void customSnackbar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(child: Text(text)),
    width: 200,
    backgroundColor: kForthColor,
    shape: StadiumBorder(),
    behavior: SnackBarBehavior.floating,
  ));
}
