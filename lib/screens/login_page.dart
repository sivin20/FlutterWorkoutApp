import 'package:auth_app/screens/sign_up_page.dart';
import 'package:auth_app/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './forgot_pw_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:auth_buttons/auth_buttons.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginScreen({Key? key, required this.showRegisterPage})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginFail = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("My Fitness Tracker")),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Icon(
              Icons.fitness_center,
              size: 100,
            ),
            SizedBox(height: 30),
            Text(
              "Welcome back!",
              style: TextStyle(fontSize: 24),
            ),
            loginFail != ""
                ? const SizedBox(
                    height: 10,
                  )
                : const SizedBox(
                    height: 0,
                  ),
            Text(
              loginFail,
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(height: 40),

            //Email textfield
            TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 4),

            //Password Textfield
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ForgotPasswordScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.lock_open, size: 32),
                label: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: signIn),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: TextStyle(),
                ),
                MaterialButton(
                  padding: EdgeInsets.only(left: 0),
                  child: Text(
                    "register here",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onPressed: widget.showRegisterPage,
                ),
              ],
            ),
            SizedBox(height: 10),
            FacebookAuthButton(
              onPressed: context.read<AuthenticationService>().signInWithFacebook,
            )
          ],
        ),
      ),
    );
  }

  void facebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final profile = await FacebookAuth.instance.getUserData();
      print(profile);
    } else {
      print(result.status);
      print(result.message);
    }
  }

  Future signIn() async {
    if (passwordController.text.isEmpty || emailController.text.isEmpty) {
      setState(() {
        loginFail = "Please provide valid login information";
      });
    }
    try {
      //Loading widget
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      //Sign in
      context.read<AuthenticationService>().signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      //Pop the loading circle
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        loginFail = "Please provide valid login information";
      });
    }
  }
}
