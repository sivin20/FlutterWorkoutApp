import 'package:auth_app/screens/login_page.dart';
import 'package:auth_app/screens/sign_up_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  // Initially, show loginpage
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginScreen(showRegisterPage: toggleScreens);
    } else {
      return SignUpScreen(showLoginPage: toggleScreens);
    }
  }
}
