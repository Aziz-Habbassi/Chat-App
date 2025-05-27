import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/models/weather_model.dart';
import 'package:chatapp_supabase/services/get_weather.dart';
import 'package:chatapp_supabase/widgets/custom_button.dart';
import 'package:chatapp_supabase/widgets/custom_snackbar.dart';
import 'package:chatapp_supabase/widgets/custom_text_field.dart';
import 'package:chatapp_supabase/widgets/weather_box.dart';
import 'package:chatapp_supabase/widgets/weather_of_the_day.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  static const id = "weatherPage";

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List<WeatherModel> list = [];
  bool locationvalid = false;
  String? location;
  int dayindex = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSixColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Check Weather",
              style: TextStyle(
                  color: kSecondColor,
                  fontFamily: "Playwrite",
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              FontAwesomeIcons.wind,
              color: kSecondColor,
            )
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        children: [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Text(
              "Enter location",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kSecondColor,
                  fontFamily: "Playwrite",
                  fontWeight: FontWeight.bold,
                  fontSize: 48),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              hinttext: "Location",
              onChanged: (data) {
                location = data;
              },
            ),
          ),
          SizedBox(
            height: 40,
          ),
          CustomButton(
            text: "Check",
            ontap: () async {
              if (location == null || location == "") {
                customSnackbar("invalid location", context);
              } else {
                try {
                  list = await GetWeather().getWeekWeather(location!);
                  locationvalid = true;
                } catch (ex) {
                  customSnackbar(
                      "There is an Error check your location", context);
                  locationvalid = false;
                }

                setState(() {
                  _scrollController.animateTo(0,
                      duration: Duration(milliseconds: 300),
                      curve: Easing.linear);
                  dayindex = 0;
                });
              }
            },
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  if (locationvalid == true) {
                    return WeatherBox(
                      date: list[index].date,
                      ontap: () {
                        dayindex = index;

                        setState(() {});
                      },
                    );
                  } else {
                    return null;
                  }
                }),
          ),
          locationvalid == true
              ? WeatherOfTheDay(
                  weatherModel: list[dayindex],
                )
              : Text(
                  "Hmm Where do you want to go this week🤔...",
                  style: TextStyle(color: kPrimaryColor, fontSize: 20),
                )
        ],
      ),
    );
  }
}
