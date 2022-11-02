import 'package:auth_app/models/user_model.dart';
import 'package:auth_app/read_data/calculate_age.dart';
import 'package:auth_app/services/authentication_service.dart';
import 'package:auth_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserModel? user;

  bool enableUpdating = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _DOBController = TextEditingController();

  Future<void> getData() async {
    String? userId = await context.read<AuthenticationService>().getUserId();
    user = await context.read<DatabaseService>().retrieveUser(userId);
    _emailController.text = user!.email;
    _firstNameController.text = user!.firstName;
    _lastNameController.text = user!.lastName;
    _DOBController.text = user!.birthday;
  }

  void updateUserInfo() async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text(
              'Please Confirm',
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'Are you sure you want to update user information?',
              textAlign: TextAlign.center,
            ),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    // Remove the box
                    String? userId = await context
                        .read<AuthenticationService>()
                        .getUserId();
                    UserModel newUserInfo = UserModel(
                        id: userId,
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        email: _emailController.text.trim(),
                        birthday: _DOBController.text.trim());
                    context.read<DatabaseService>().updateUser(newUserInfo);
                    setState(() {
                      enableUpdating = false;
                    });
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.blue),
                  )),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  void enableUpdate() {
    setState(() {
      enableUpdating = true;
    });
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: [
              SizedBox(
                height: 10,
              ),

              //Email
              TextField(
                readOnly: !enableUpdating,
                controller: _emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: !enableUpdating,
                  fillColor: Colors.grey[300],
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
              SizedBox(
                height: 10,
              ),

              //First name
              TextField(
                readOnly: !enableUpdating,
                controller: _firstNameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: !enableUpdating,
                  fillColor: Colors.grey[300],
                  labelText: 'First name',
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
              SizedBox(
                height: 10,
              ),

              // Last name
              TextField(
                readOnly: !enableUpdating,
                controller: _lastNameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: !enableUpdating,
                  fillColor: Colors.grey[300],
                  labelText: 'Last name',
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
              SizedBox(
                height: 10,
              ),

              // Date of Birth
              TextField(
                readOnly: !enableUpdating,
                enableInteractiveSelection: !enableUpdating,
                controller: _DOBController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  filled: !enableUpdating,
                  fillColor: Colors.grey[300],
                  labelText: 'Birthdate',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: !enableUpdating
                    ? () {}
                    : () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1910),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          _DOBController.text = formattedDate;
                        }
                      },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: !enableUpdating ? enableUpdate : updateUserInfo,
                child: Text(
                    !enableUpdating ? 'Update user information' : 'Submit'),
              )
            ]),
          );
        },
      ),
    );
  }
}
