import 'package:auth_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addUser(UserModel userModel, String documentId) async {
    await _db.collection('users').doc(documentId).set(userModel.toMap());
  }

  updateUser(UserModel userModel) async {
    await _db.collection('users').doc(userModel.id).update(userModel.toMap());
  }

  Future<void> deleteUser(String documentId) async {
    await _db.collection('users').doc(documentId).delete();
  }

  Future<UserModel> retrieveUser(String userId) async {
   DocumentSnapshot<Map<String, dynamic>> docRef = await _db.collection('users').doc(userId).get();
   return UserModel.fromDocumentSnapshot(docRef);
  }

  Future<List<UserModel>> retrieveUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('users').get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
