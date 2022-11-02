import 'package:auth_app/models/user_model.dart';
import 'package:auth_app/services/authentication_service.dart';
import 'package:auth_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;


  const SignUpScreen({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  String errorMessage = "";
  DatabaseService databaseService = DatabaseService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {
      if (passwordConfirmed()) {
        // create user
        await context.read<AuthenticationService>().signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        String docId = await context.read<AuthenticationService>().getUserId() as String;
        UserModel user = UserModel(
            id: docId,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            birthday: _birthdayController.text.trim(),
            email: _emailController.text.trim(),
        );
        databaseService.addUser(user, docId);

        // add user details

      }
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
            _confirmPasswordController.text.trim() &&
        !_passwordController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("My Fitness Tracker")),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Join the family!",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            //First name textfield
            TextField(
              controller: _firstNameController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'First Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 4),

            //Last name textfield
            TextField(
              controller: _lastNameController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Last Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 4),

            //Age

            TextField(
              controller: _birthdayController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Enter birthdate',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1910),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  print(pickedDate);
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                  setState(() {
                    _birthdayController.text = formattedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 4),

            //Email textfield
            TextField(
              controller: _emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _passwordController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 4),
            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 5),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.lock_open, size: 32),
              label: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signUp,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already a member? ",
                  style: TextStyle(),
                ),
                MaterialButton(
                  child: const Text(
                    "log in here",
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: widget.showLoginPage,
                  padding: const EdgeInsets.only(left: 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
