import 'package:chatapp_supabase/constants/constants.dart';
import 'package:flutter/material.dart';

class WeatherBox extends StatelessWidget {
  const WeatherBox({super.key, required this.date, required this.ontap});
  final String date;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: Alignment.center,
        height: 70,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), color: kFifthColor),
        child: Text(
          date,
          style: TextStyle(
              color: kForthColor, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
