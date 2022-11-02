import 'package:auth_app/screens/settings.dart';
import 'package:auth_app/screens/workout_entries/create_legs_page.dart';
import 'package:auth_app/screens/workout_entries/create_pull_page.dart';
import 'package:auth_app/screens/workout_entries/create_push_page.dart';
import 'package:auth_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../read_data/get_user_name.dart';
import '../services/authentication_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser!;
  String dropdownValue = 'Push';

  // document IDs
  List<String> docIDs = [];

  Future getDocId() async {
    docIDs = [];
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('DOB')
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  void switchToEntryPages() {
    print(dropdownValue);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        if (dropdownValue == 'Push') {
          return const CreatePushEntryPage();
        }
        if (dropdownValue == 'Pull') {
          return const CreatePullEntryPage();
        }
        if (dropdownValue == 'Legs') {
          return const CreateLegsEntryPage();
        } else {
          return const HomePage();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.read<AuthenticationService>().signOut();
          },
          child: Icon(Icons.logout),
        ),
        centerTitle: true,
        title: Text(
          user.email!,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
                child: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SettingsPage();
                    }),
                  );
                }),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text('Create a new workout entry:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[300],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        elevation: 24,
                        borderRadius: BorderRadius.circular(12),
                        underline: Container(
                          height: 2,
                          color: Colors.blueAccent,
                        ),
                        items: <String>['Push', 'Pull', 'Legs']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: switchToEntryPages,
                        child: Text('Create a new ${dropdownValue} entry'))
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getDocId(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: GetUserName(documentId: docIDs[index]),
                          tileColor: Colors.grey[300],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
