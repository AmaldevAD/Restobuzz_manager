import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

var current;

class Auth {
  BuildContext context;
  Auth({this.context});
  //SignUP
  Future<bool> signUp({@required email, @required password}) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      addDetailsToFirebase();
      return true;
    } catch (e) {
      // handleError(e);
      String error;
      print(e.toString());
      if (e is PlatformException )
        error = "Email Already Exist";
      else
        error = e.toString();
      alert(error);
      return false;
    }
  }

  //LOgin
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: "$email", password: "$password");
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




  alert(error){
    showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              title: Text(
                '$error',
                style: TextStyle(color: Color(0xff3a3a3a)),
              ),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  child: Text("ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
  }

  addDetailsToFirebase()async{

  }
}
