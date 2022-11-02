import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;

  final String firstName;
  final String lastName;
  final String email;
  final String birthday;

  UserModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.birthday});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'DOB': birthday,
    };
  }

  UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        firstName = doc.data()!['first_name'],
        lastName = doc.data()!['last_name'],
        email = doc.data()!['email'],
        birthday = doc.data()!['DOB'];
}
