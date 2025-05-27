import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/pages/login_page.dart';
import 'package:chatapp_supabase/widgets/custom_button.dart';
import 'package:chatapp_supabase/widgets/custom_snackbar.dart';
import 'package:chatapp_supabase/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  static const id = "ResetPasswordPage";
  String? password;
  String? confirmpassword;
  GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Future<void> updatepassword() async {
      try {
        await Supabase.instance.client.auth
            .updateUser(UserAttributes(password: password));
        customSnackbar("Your password has been updated", context);
        await Future.delayed(Duration(seconds: 2));
        Supabase.instance.client.auth.signOut();
        Navigator.popAndPushNamed(context, LoginPage.id);
      } on AuthException catch (e) {
        if (e.message.contains("ClientException with SocketException")) {
          customSnackbar("check Your connection", context);
        } else {
          customSnackbar(e.message, context);
        }
      } catch (e) {
        customSnackbar(e.toString(), context);
      }
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text("Reset Your password",
            style: TextStyle(
                color: kFifthColor,
                fontFamily: "Playwrite",
                fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 200, horizontal: 20),
          children: [
            CustomTextField(
              hinttext: "New Password",
              onChanged: (data) {
                password = data;
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              hinttext: "confirm New Password",
              onChanged: (data) {
                confirmpassword = data;
              },
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              text: "Update Password",
              ontap: () {
                if (formkey.currentState!.validate()) {
                  if (password == confirmpassword) {
                    updatepassword();
                  } else {
                    customSnackbar("confirm password correctly", context);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
