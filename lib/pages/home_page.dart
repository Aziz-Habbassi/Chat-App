import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/models/profil_model.dart';
import 'package:chatapp_supabase/pages/loading_screen.dart';
import 'package:chatapp_supabase/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  static const id = "HomePage";
  SupabaseClient supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: get_info(supabase.auth.currentUser!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ProfilModel user = ProfilModel.fromJson(snapshot.data);
            return Scaffold(
                drawer: NavBar(
                  user: user,
                ),
                appBar: AppBar(
                  backgroundColor: const Color(0xfffefae0),
                  title: Text(
                    "Welcome",
                    style: TextStyle(
                        color: kForthColor,
                        fontFamily: "Playwrite",
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
                body: Center(
                  child: Text("Welcome Backk !! ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kForthColor,
                          fontSize: 72,
                          fontFamily: "Playwrite",
                          fontWeight: FontWeight.bold)),
                ));
          } else {
            return LoadingScreen();
          }
        });
  }

  Future<Map<String, dynamic>> get_info(User user) async {
    final response =
        await supabase.from('profiles').select().eq('id', user.id).single();

    return response;
  }
}
