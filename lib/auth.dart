import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in with email & password
  Future loginwithemail(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // ignore: unused_local_variable
      User? user = result.user;
      return FirebaseAuth.instance.currentUser!.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register wit email and pwd
  Future registerwithemail(
      String username,
      String phone,
      String email,
      String password,
      String sponsor,
      String balance,
      String recruited,
      String slots) async {
    try {
      //create auth email and pasword
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //update user document with new data, matching the user id

      //create 4 collections for this user with their id
      await user!.sendEmailVerification();
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future sendPasswordResetLink(String email) async {
    try {
      return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      if (e.code.contains('not-found')) {
        return null;
      }
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
