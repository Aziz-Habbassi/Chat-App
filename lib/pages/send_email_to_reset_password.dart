import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/widgets/custom_button.dart';
import 'package:chatapp_supabase/widgets/custom_snackbar.dart';
import 'package:chatapp_supabase/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SendEmailToResetPassword extends StatelessWidget {
  SendEmailToResetPassword({super.key});
  static const id = "SendEmailToResetPassword";
  String? email;
  GlobalKey<FormState> formkey = GlobalKey();
  SupabaseClient supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    Future<void> resetpassword(String email) async {
      try {
        await supabase.auth.resetPasswordForEmail(email,
            redirectTo: 'chatapp://reset-password');
        customSnackbar("check your E-mail", context);
      } on AuthException catch (e) {
        if (e.message.contains("ClientException with SocketException")) {
          customSnackbar("check Your connection", context);
        } else {
          customSnackbar(e.message, context);
        }
      } catch (ex) {
        customSnackbar(ex.toString(), context);
      }
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text("Reset Your password",
            style: TextStyle(
                color: kFifthColor,
                fontFamily: "Playwrite",
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 200, horizontal: 20),
        children: [
          Form(
            key: formkey,
            child: CustomTextField(
              hinttext: "E-mail",
              onChanged: (data) {
                email = data;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(
            text: "Reset password",
            ontap: () {
              if (formkey.currentState!.validate()) {
                resetpassword(email!);
              }
            },
          )
        ],
      ),
    );
  }
}
