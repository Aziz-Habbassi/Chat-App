import 'package:chatapp_supabase/models/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetWeather {
  Future<List<WeatherModel>> getWeekWeather(String location) async {
    await dotenv.load(fileName: '.env');
    final String apikey = dotenv.env['WEATHERKEY']!;
    Response response = await Dio().get(
        "https://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$location&days=7&aqi=no&alerts=no");
    List<WeatherModel> list = [];
    for (int i = 0; i < 7; i++) {
      dynamic day = response.data["forecast"]["forecastday"][i];
      list.add(WeatherModel(
          location: response.data["location"]["name"],
          temp: day["day"]["avgtemp_c"],
          date: day["date"],
          condition: day["day"]["condition"]["text"],
          image: day["day"]["condition"]["icon"],
          sunrise: day["astro"]["sunrise"],
          sunset: day["astro"]["sunset"]));
    }
    return list;
  }
}
