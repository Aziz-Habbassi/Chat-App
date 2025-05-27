import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/pages/chat_page.dart';
import 'package:chatapp_supabase/pages/home_page.dart';
import 'package:chatapp_supabase/pages/login_page.dart';
import 'package:chatapp_supabase/pages/profile_page.dart';
import 'package:chatapp_supabase/pages/reset_password_page.dart';
import 'package:chatapp_supabase/pages/send_email_to_reset_password.dart';
import 'package:chatapp_supabase/pages/signup_page.dart';
import 'package:chatapp_supabase/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app_links/app_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void handleDeepLink(Uri? uri) {
  if (uri != null && uri.host == ('reset-password')) {
    final accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;
    if (accessToken != null) {
      navigatorKey.currentState?.pushNamed(ResetPasswordPage.id);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASEURL']!,
    anonKey: dotenv.env['SUPABASEKEY']!,
  );
  final appLinks = AppLinks();
  Uri? initialUri = await appLinks.getInitialLink();
  handleDeepLink(initialUri);

  appLinks.uriLinkStream.listen((Uri? uri) {
    handleDeepLink(uri);
  });
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        SignupPage.id: (context) => SignupPage(),
        HomePage.id: (context) => HomePage(),
        ProfilePage.id: (context) => ProfilePage(),
        ChatPage.id: (context) => ChatPage(),
        ResetPasswordPage.id: (context) => ResetPasswordPage(),
        SendEmailToResetPassword.id: (context) => SendEmailToResetPassword(),
        WeatherPage.id: (context) => WeatherPage()
      },
      initialRoute: LoginPage.id,
      debugShowCheckedModeBanner: false,
    );
  }
}
