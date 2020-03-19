import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

var current;

class Auth {
  BuildContext context;
  Auth({this.context}) {}
  //SignUP
  Future<FirebaseUser> signUp(email, password) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "amal2@gmail.com", password: "password");
      FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;
    } catch (e) {
      // handleError(e);
      print(e.toString());
      return null;
    }
  }

  //LOgin
  Future<bool> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "$email", password: "$password");
      FirebaseUser user = result.user;
      _prefs.setString("user", "${user.uid}");
      print(user.email);
      //print(result);
      return true;
    } catch (e) {
    //  print(e);
    print(e);
      return false;
    }
  }

  Future<String> currentUser() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print(user.uid);
      return user.uid;
    } catch (e) {
      print("----$e");
      return null;
    }
  }

  Future<String> signOut() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove("user");
    await FirebaseAuth.instance.signOut();
  }
}
