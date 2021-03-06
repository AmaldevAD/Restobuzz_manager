import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:restobudzz/screens/homeScreenNavigator.dart';
import 'package:restobudzz/screens/login.dart';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _prefs;
var user;

final FirebaseApp app = FirebaseApp(
  name: "restobudzz",
);
final FirebaseDatabase dat = FirebaseDatabase(app: app);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _prefs = await SharedPreferences.getInstance();
  user = _prefs.getString("user");
  print("user");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(user);
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            buttonColor: Colors.black,
            secondaryHeaderColor: Colors.white,
            focusColor: Colors.black),
        home: user == null ? Login() : HomeScreenNavigator());
  }
}
