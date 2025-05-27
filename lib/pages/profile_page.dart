import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/models/profil_model.dart';
import 'package:chatapp_supabase/widgets/custom_button.dart';
import 'package:chatapp_supabase/widgets/custom_snackbar.dart';
import 'package:chatapp_supabase/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  static const String id = "ProfilePage";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  XFile? _imageProvider;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user_profil =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ProfilModel user = user_profil['user'];

    String? name;
    return Scaffold(
        backgroundColor: kSixColor,
        appBar: AppBar(
          backgroundColor: kSixColor,
          centerTitle: true,
          title: Text(
            "Your Profil",
            style: TextStyle(
                color: kFifthColor,
                fontFamily: "Playwrite",
                fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 90),
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  radius: 100,
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: _imageProvider == null
                        ? NetworkImage(user.profilpicurl)
                        : FileImage(File(_imageProvider!.path)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 150, left: 150),
                    child: Container(
                      height: 50,
                      width: 65,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(24)),
                      child: IconButton(
                          highlightColor: kSixColor,
                          onPressed: () {
                            updateImage(context);
                          },
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                          )),
                    ))
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 150, top: 40),
                  child: Text(
                    "Your Name",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontFamily: "Playwrite",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: CustomTextField(
                    hinttext: user.name,
                    onChanged: (data) {
                      name = data;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                isLoading
                    ? LoadingAnimationWidget.horizontalRotatingDots(
                        color: kFifthColor, size: 48)
                    : CustomButton(
                        text: "Confirm Changes",
                        ontap: () {
                          saveChanges(user, _imageProvider, name);
                        }),
                TextButton(
                    onPressed: () {
                      resetPassword(user);
                    },
                    child: Text(
                      "Change Password ?",
                      style: TextStyle(
                        color: kThirdColor,
                      ),
                    ))
              ],
            )
          ],
        ));
  }

  Future<void> updateImage(BuildContext context) async {
    XFile? newImage;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kPrimaryColor,
            title: Text(
              "Choose :",
              style: TextStyle(fontFamily: "Playwrite", color: kFifthColor),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () async {
                      newImage = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (newImage != null) {
                        setState(() {
                          _imageProvider = newImage;
                        });
                      }
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.camera,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () async {
                      newImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (newImage != null) {
                        setState(() {
                          _imageProvider = newImage;
                        });
                      }
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                    ))
              ],
            ),
          );
        });
  }

  Future<void> uploadNewImage(ProfilModel user, XFile image) async {
    await supabase.storage
        .from('profil_pictures')
        .update(user.id, File(image.path));
  }

  Future<void> saveChanges(
      ProfilModel user, XFile? newImage, String? name) async {
    try {
      if (name != null || newImage != null) {
        setState(() {
          isLoading = true;
        });
        if (user.name != name && name != null) {
          await supabase
              .from('profiles')
              .update({'name': name}).eq('id', user.id);
        }
        if (newImage != null) {
          uploadNewImage(user, newImage);
        }
        if (mounted) {
          final response = await supabase
              .from('profiles')
              .select('name')
              .eq('id', user.id)
              .single();

          setState(() {
            user.profilpicurl =
                '${supabase.storage.from('profil_pictures').getPublicUrl(user.id)}?t=${DateTime.now().millisecondsSinceEpoch}';
            if (name != null) {
              user.name = response['name'];
            }
            isLoading = false;
          });
        }
        customSnackbar("Changes Saved", context);
      }
    } on AuthException catch (e) {
      customSnackbar(e.message, context);
    } catch (e) {
      customSnackbar(e.toString(), context);
    }
  }

  Future<void> resetPassword(ProfilModel user) async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.auth.resetPasswordForEmail(user.email,
          redirectTo: 'chatapp://reset-password');
    } on AuthException catch (e) {
      if (e.message.contains("ClientException with SocketException")) {
        customSnackbar("check Your connection", context);
      } else {
        customSnackbar(e.message, context);
      }
    } catch (ex) {
      customSnackbar(ex.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
    customSnackbar("Check Your E-mail", context);
  }
}
