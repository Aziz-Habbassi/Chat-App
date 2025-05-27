import 'dart:io';

import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/widgets/custom_button.dart';
import 'package:chatapp_supabase/widgets/custom_snackbar.dart';
import 'package:chatapp_supabase/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});
  static const id = "SignUpPage";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? name;
  String? email;
  String? password;
  bool isLoading = false;
  XFile? _image;
  SupabaseClient supabase = Supabase.instance.client;
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: ListView(
        children: [
          Center(
            child: Text(
              "Make an Account",
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
          CircleAvatar(
            radius: 100,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: kPrimaryColor,
              backgroundImage:
                  _image == null ? null : FileImage(File(_image!.path)),
            ),
          ),
          IconButton(
              onPressed: () {
                pickImage();
              },
              icon: Icon(
                FontAwesomeIcons.cameraRetro,
                color: Colors.white,
              )),
          Center(
            child: Text(
              "Upload a Profil pic",
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
                        "Sign Up",
                        style: TextStyle(fontSize: 32, color: kThirdColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    hinttext: "Name",
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      hinttext: "E-mail",
                      onChanged: (value) {
                        email = value;
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      hinttext: "Password",
                      onChanged: (value) {
                        password = value;
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  !isLoading
                      ? CustomButton(
                          text: "Sign Up",
                          ontap: () {
                            if (formkey.currentState!.validate() &&
                                validate_profill_pic(_image)) {
                              setState(() {
                                isLoading = true;
                              });
                              signUp(name!, email!, password!, _image!);
                            }
                          },
                        )
                      : LoadingAnimationWidget.horizontalRotatingDots(
                          color: kSecondColor, size: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account ?",
                        style: TextStyle(color: kSecondColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: kForthColor),
                        ),
                      )
                    ],
                  )
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

  Future<void> pickImage() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kSixColor,
            title: Text(
              "Choose :",
              style: TextStyle(fontFamily: "Playwrite", color: kFifthColor),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      var image = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      setState(() {
                        _image = image;
                      });
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: kFifthColor,
                    )),
                IconButton(
                    onPressed: () async {
                      var image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {
                        _image = image;
                      });
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.photo,
                      color: kFifthColor,
                    ))
              ],
            ),
          );
        });
  }

  Future<void> signUp(
      String name, String email, String password, XFile image) async {
    try {
      await supabase.auth.signUp(email: email, password: password);
      await supabase.storage
          .from('profil_pictures')
          .upload(supabase.auth.currentUser!.id, File(image.path));
      String profil_pic_url = supabase.storage
          .from('profil_pictures')
          .getPublicUrl(supabase.auth.currentUser!.id);
      await supabase.from('profiles').insert({
        "id": supabase.auth.currentUser!.id,
        "email": email,
        "name": name,
        "profil_pic": profil_pic_url
      });
      customSnackbar("Welcome $name", context);
      Supabase.instance.client.auth.signOut();
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

  bool validate_profill_pic(XFile? image) {
    if (image == null) {
      customSnackbar("Please Upload your profil picture", context);
      return false;
    } else {
      return true;
    }
  }
}
