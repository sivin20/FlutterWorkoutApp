import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName({required this.documentId});

  String calculateAge(String birthDay) {
    DateTime currentDate = DateTime.now();
    var date = DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(birthDay));
    DateTime bDate = DateTime.parse(date);
    int age = currentDate.year - bDate.year;
    String ageString = age.toString();
    return ageString;
  }

  @override
  Widget build(BuildContext context) {
    //Get collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
        builder: ((context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Text('${data['first_name']} ${data['last_name']}, ${calculateAge('${data['DOB']}')} years old');
      }
      return Text('loading..');
    }));
  }
}
