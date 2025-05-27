import 'dart:ffi';

import 'package:flutter/material.dart';

class WeatherModel {
  final String location;
  final double temp;
  final String date;
  final String condition;
  final String image;
  final String sunrise;
  final String sunset;

  WeatherModel(
      {required this.location,
      required this.temp,
      required this.date,
      required this.condition,
      required this.image,
      required this.sunrise,
      required this.sunset});
}
