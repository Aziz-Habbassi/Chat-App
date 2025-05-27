import 'dart:io';

import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/pages/home_page.dart';
import 'package:chatapp_supabase/pages/send_email_to_reset_password.dart';
import 'package:chatapp_supabase/pages/signup_page.dart';
import 'package:chatapp_supabase/widgets/custom_button.dart';
import 'package:chatapp_supabase/widgets/custom_snackbar.dart';
import 'package:chatapp_supabase/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static const id = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  bool isLoading = false;
  String? password;
  bool hidepassword = true;
  GlobalKey<FormState> formkey = GlobalKey();
  SupabaseClient supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: ListView(
        children: [
          SizedBox(
            height: 80,
          ),
          Center(
            child: Text(
              "Welcome Back",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kSecondColor,
                  fontFamily: "Playwrite",
                  fontWeight: FontWeight.bold,
                  fontSize: 48),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Image.asset(
            "lib/images/home_screen_logo.png",
            height: 200,
          ),
          Center(
            child: Text(
              "Join to the team",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kSecondColor,
                  fontFamily: "Playwrite",
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(fontSize: 32, color: kThirdColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    hinttext: "E-mail",
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hinttext: "Password",
                    onChanged: (value) {
                      password = value;
                    },
                    obscure: true,
                    hidepassword: hidepassword,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                    pressed: () {
                      setState(() {
                        hidepassword = !hidepassword;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SendEmailToResetPassword.id);
                          },
                          child: Text(
                            "Forgot password ?",
                            style: TextStyle(color: kForthColor),
                          )),
                    ],
                  ),
                  !isLoading
                      ? CustomButton(
                          text: "Login",
                          ontap: () {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              login(email!, password!);
                            }
                          },
                        )
                      : LoadingAnimationWidget.horizontalRotatingDots(
                          color: kSecondColor, size: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account ?",
                        style: TextStyle(color: kSecondColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignupPage.id);
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: kForthColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Future<void> login(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      Navigator.pushNamed(context, HomePage.id);
    } on AuthException catch (e) {
      if (e.message.contains("ClientException with SocketException")) {
        customSnackbar("check Your connection", context);
      } else {
        customSnackbar(e.message, context);
      }
    } catch (e) {
      customSnackbar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }
}
