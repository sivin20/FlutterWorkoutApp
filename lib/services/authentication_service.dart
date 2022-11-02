import 'package:auth_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../models/user_model.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanged => _firebaseAuth.authStateChanges();

  Future<String> getUserId() async {
    try {
      User? user = await _firebaseAuth.currentUser;
      String? userId = user?.uid;
      return userId as String;
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> signInWithFacebook() async {
    FacebookAuth fb = FacebookAuth.instance;
    LoginResult result = await fb.login();
    if (result.status == LoginStatus.success) {
      final AuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken?.token as String,
      );
      final User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      String userId = user!.uid;
      final profile = await FacebookAuth.instance.getUserData(fields: "first_name, last_name, email, birthday");
      print(profile);
      DatabaseService db = DatabaseService();
      if(db.retrieveUser(userId) == null) {
        UserModel usermodel = UserModel(id: userId, firstName: profile['first_name'], lastName: profile['last_name'], email: profile['email'], birthday: '01-01-1970');
        db.addUser(usermodel, userId);
      }

      return "Signed in with Facebook succesfully";
    } else {
      return "Unsuccesful sign in with Facebook :(";
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
