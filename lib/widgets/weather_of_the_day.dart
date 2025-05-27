import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/models/weather_model.dart';
import 'package:flutter/material.dart';

class WeatherOfTheDay extends StatelessWidget {
  const WeatherOfTheDay({super.key, required this.weatherModel});
  final WeatherModel weatherModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 350,
      width: 400,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: fetchgradient(weatherModel)),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Sunrise : ${weatherModel.sunrise}",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          Text(
            weatherModel.location,
            style: TextStyle(
                color: const Color.fromARGB(255, 78, 57, 0),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Image.network(
            "https:${weatherModel.image}",
            scale: 0.45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("temp : ${weatherModel.temp}",
                  style: TextStyle(color: kFifthColor, fontSize: 20)),
              Text("condition : \n${weatherModel.condition}",
                  style: TextStyle(color: kFifthColor, fontSize: 18))
            ],
          ),
          Text(
            "sunset : ${weatherModel.sunset}",
            style: TextStyle(color: kFifthColor, fontSize: 20),
          )
        ],
      ),
    );
  }

  List<Color> fetchgradient(WeatherModel model) {
    List<Color> sunny = [Colors.yellow, Colors.deepOrange, Colors.black];
    List<Color> rain = [
      Colors.lightBlueAccent,
      const Color.fromARGB(255, 0, 81, 156),
      const Color.fromARGB(255, 0, 0, 0)
    ];
    List<Color> cloud = [Colors.white24, Colors.grey, Colors.blueGrey];

    if (["Sunny", "Sunny"].contains(model.condition.trim())) {
      return sunny;
    } else if (["Partly Cloudy", "Cloudy", "Overcast"]
        .contains(model.condition.trim())) {
      return cloud;
    } else {
      return rain;
    }
    ;
  }
}
