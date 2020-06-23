import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:restobudzz/auth/authentication.dart';
import 'package:restobudzz/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

String hotelId;

class UserViewRestaurantDetail extends StatefulWidget {
  UserViewRestaurantDetail(id) {
    hotelId = id;
  }

  @override
  _UserViewRestaurantDetailState createState() =>
      _UserViewRestaurantDetailState();
}

class _UserViewRestaurantDetailState extends State<UserViewRestaurantDetail> {
  Auth _auth;
  SharedPreferences _prefs;
  FirebaseDatabase db = FirebaseDatabase.instance;

  var hotel;
  String name;
  String phone;
  String email;

  StreamSubscription<Event> _onFoodAddedSubscription;
  StreamSubscription<Event> _onFoodChangedSubscription;
  final FirebaseApp app = FirebaseApp(
    name: "[DEFAULT]",
  );

  DatabaseReference itemRef;

  @override
  void initState() {
    super.initState();
    _auth = Auth(context: context);
    init();
  }

  init() async {
    _prefs = await SharedPreferences.getInstance();
    final FirebaseDatabase _database = FirebaseDatabase(app: app);

    itemRef = _database.reference().child("$hotelId");
    itemRef.once().then((value) {
      setState(() {
        name = value.value["name"];
        email = value.value["email"];
        phone = value.value["phone"];
      });
    });
    // itemRef.onChildAdded.listen(onEntryAdded);
    //itemRef.onChildRemoved.listen(onEntrydeleted);
  }

  // onEntrydeleted(Event event) {
  //   print(" hooooooooooooooooooooooooooo");
  //   // var oldEntry = _hotel.singleWhere((entry) {
  //   //   return entry.hotelId == event.snapshot.key;
  //   // });

  //   setState(() {
  //     // _food[_food.indexOf(oldEntry)] = Food.fromSnapshot(event.snapshot);
  //     // _hotel.removeAt(_hotel.indexOf(oldEntry));
  //     // keys.add(event.snapshot.key);
  //     hotel
  //   });
  // }

  // onEntryAdded(Event event) {
  //   print(" hooooooooooooooooooooooooooo");
  //   print(event.snapshot.key);

  //   setState(() {
  //     hotel = event.snapshot.key;
  //   });

  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("UserViewRestaurantDetail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: width / 2,
                height: width / 2,

                //orginal image
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: Colors.black),
                    // image: new DecorationImage(
                    //   fit: BoxFit.fill,
                    //   image: new NetworkImage(
                    //       "https://scontent-sea1-1.cdninstagram.com/vp/93a2a07ab99dba59649bbc2d8f0eab37/5E4AE35E/t51.2885-19/s150x150/74532804_2719612848078426_305338747015135232_n.jpg?_nc_ht=scontent-sea1-1.cdninstagram.com"),
                    // ),
                  ),
                  child: Icon(
                    Icons.domain,
                    size: 70,
                    color: Colors.grey[600],
                  ),
                ),
                decoration: new BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              margin: const EdgeInsets.only(top: 3, left: 10, bottom: 3),
              child: Text(
                "Restaurant Details:",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Name    :           ",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$name",
                        style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Email     :           ",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$email:",
                        style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Phone    :          ",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$phone",
                        style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
