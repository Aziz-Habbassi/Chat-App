import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/models/profil_model.dart';
import 'package:chatapp_supabase/pages/chat_page.dart';
import 'package:chatapp_supabase/pages/login_page.dart';

import 'package:chatapp_supabase/pages/profile_page.dart';
import 'package:chatapp_supabase/pages/weather_page.dart';
import 'package:chatapp_supabase/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NavBar extends StatelessWidget {
  NavBar({
    super.key,
    required this.user,
  });
  ProfilModel user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kFifthColor,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilpicurl)),
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: kSixColor,
              ),
              accountName: Text(
                user.name,
              ),
              accountEmail: Text(user.email)),
          ListTile(
            onTap: () {
              Navigator.popAndPushNamed(context, ProfilePage.id,
                  arguments: {'user': user});
            },
            leading: FaIcon(
              FontAwesomeIcons.user,
              color: kSixColor,
            ),
            title: Text(
              "Profile",
              style: TextStyle(color: kSixColor, fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.popAndPushNamed(context, ChatPage.id,
                  arguments: {'user': user});
            },
            leading: FaIcon(
              FontAwesomeIcons.message,
              color: kSixColor,
            ),
            title: Text(
              "Chat",
              style: TextStyle(color: kSixColor, fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.popAndPushNamed(
                context,
                WeatherPage.id,
              );
            },
            leading: FaIcon(
              FontAwesomeIcons.cloudSunRain,
              color: kSixColor,
            ),
            title: Text(
              "Check Weather",
              style: TextStyle(color: kSixColor, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 450),
            child: CustomButton(
              text: "Sign out",
              ontap: () {
                Supabase.instance.client.auth.signOut();
                Navigator.popAndPushNamed(context, LoginPage.id);
              },
            ),
          )
        ],
      ),
    );
  }
}
