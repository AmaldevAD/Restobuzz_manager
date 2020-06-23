import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restobudzz/auth/authentication.dart';
import 'package:restobudzz/models/food.dart';
import 'dart:async';

import 'package:restobudzz/screens/userViewRestuarentDetails.dart';

String hotelId;

class UserViewFood extends StatefulWidget {
  UserViewFood(id) {
    hotelId = id;
  }

  @override
  _UserViewFoodState createState() => _UserViewFoodState();
}

class _UserViewFoodState extends State<UserViewFood> {
  bool isSwitched = false;
  String activityStatus = "Closed";
  final FirebaseApp app = FirebaseApp(name: "[DEFAULT]");
  FirebaseDatabase db = FirebaseDatabase.instance;
  DatabaseReference itemRef;
  Auth _auth;
  List<Food> _food = List();
  Query _foodQuerry;
  StreamSubscription<Event> _onFoodAddedSubscription;
  StreamSubscription<Event> _onFoodChangedSubscription;

  @override
  void initState() {
    super.initState();
    print(app.name);
    initFood();
  }

  initFood() async {
    //hotelId = await _auth.currentUser();
    print(" $hotelId");
    final FirebaseDatabase _database = FirebaseDatabase(app: app);
    _foodQuerry = await _database
        .reference()
        .child('$hotelId')
        .child("food")
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
    });
    itemRef = _database.reference().child('$hotelId').child("food");
    itemRef.onChildChanged.listen(onEntryChanged);
    itemRef.onChildAdded.listen(onEntryAdded);
    itemRef.onChildRemoved.listen(onEntrydeleted);
  }

  @override
  void dispose() {
    //_onFoodAddedSubscription.cancel();
    // _onFoodChangedSubscription.cancel();
    super.dispose();
  }

  onEntrydeleted(Event event) {
    print(" hooooooooooooooooooooooooooo");
    var oldEntry = _food.singleWhere((entry) {
      return entry.food == event.snapshot.key;
    });

    setState(() {
      // _food[_food.indexOf(oldEntry)] = Food.fromSnapshot(event.snapshot);
      _food.removeAt(_food.indexOf(oldEntry));
    });
  }

  onEntryChanged(Event event) {
    print(" hooooooooooooooooooooooooooo");
    var oldEntry = _food.singleWhere((entry) {
      return entry.food == event.snapshot.key;
    });

    setState(() {
      _food[_food.indexOf(oldEntry)] = Food.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    print(" hooooooooooooooooooooooooooo");
    setState(() {
      _food.add(Food.fromSnapshot(event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Food Availability"),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserViewRestaurantDetail(hotelId),
                        ),
                      );
                    },
                    child: Text("details"),
                  ),
                ),
              ],
            )
          ],
        ),
        body: _food.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Please add food items from items tab",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //limited items list
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: limitedItems(width),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: availableItems(width),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: overItems(width),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Row hotelStatus() {
    return Row(
      children: <Widget>[
        Text(
          "$activityStatus",
          style: TextStyle(color: isSwitched ? Colors.green : Colors.red),
        ),
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              if (isSwitched) {
                activityStatus = "Open";
                db.reference().child("$hotelId").update({"open": true});
              } else {
                activityStatus = "Closed";
                db.reference().child("$hotelId").update({"open": false});
              }
              print(isSwitched);
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ],
    );
  }

  //limited List
  limitedItems(width) {
    List<Widget> limited = [];

    for (int i = 0; i < _food.length; i++) {
      if (_food[i].limited == true) {
        setState(() {
          limited.add(
            Container(
              //padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "${_food[i].food} :",
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey[700]),
                          ),
                          Text(
                            " ₹${_food[i].price}",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        margin: EdgeInsets.only(top: 3),
                        child: Text(_food[i].description,
                            maxLines: null,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),

                  //options
                  Container(
                    width: width / 3.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "limited",
                          style: TextStyle(
                              fontSize: width / 45, color: Colors.yellow[900]),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.yellow[800]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.yellow[800],
                            ),
                            margin: EdgeInsets.all(5),
                            width: 10,
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });

        limited.add(Divider());
      }
    }
    if (limited.length > 0) {
      limited.insert(
          0,
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              "Limited :",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
          ));

      limited.insert(1, Divider());
    }
    return limited;
  }

  availableItems(width) {
    List<Widget> available = [];
    available.clear();
    for (int i = 0; i < _food.length; i++) {
      if (_food[i].available == true) {
        setState(() {
          available.add(
            Container(
              //padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "${_food[i].food} :",
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey[700]),
                          ),
                          Text(
                            " ₹${_food[i].price}",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        margin: EdgeInsets.only(top: 3),
                        child: Text(_food[i].description,
                            maxLines: null,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),

                  //options
                  Container(
                    width: width / 3.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "available",
                          style: TextStyle(
                              fontSize: width / 45, color: Colors.green),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.green),
                              borderRadius: BorderRadius.circular(20)),
                          child: InkWell(
                            onTap: () {
                              Food f = Food(price: _food[i].price);
                              db
                                  .reference()
                                  .child("$hotelId")
                                  .child("food")
                                  .child("${_food[i].food}")
                                  .update(f.setAvailable());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              margin: EdgeInsets.all(5),
                              width: 10,
                              height: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });

        available.add(Divider());
      }
    }
    if (available.length > 0) {
      available.insert(
          0,
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              "Available:",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
          ));

      available.insert(1, Divider());
    }
    return available;
  }

  //Over List
  overItems(width) {
    List<Widget> over = [];
    over.clear();
    for (int i = 0; i < _food.length; i++) {
      if (_food[i].available == false && _food[i].limited == false) {
        setState(() {
          over.add(
            Container(
              //padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "${_food[i].food} :",
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey[700]),
                          ),
                          Text(
                            " ₹${_food[i].price}",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        margin: EdgeInsets.only(top: 3),
                        child: Text(_food[i].description,
                            maxLines: null,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),

                  //options
                  Container(
                    width: width / 3.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "over",
                          style: TextStyle(
                              fontSize: width / 45, color: Colors.red),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                          child: InkWell(
                            onTap: () {
                              Food f = Food(price: _food[i].price);
                              db
                                  .reference()
                                  .child("$hotelId")
                                  .child("food")
                                  .child("${_food[i].food}")
                                  .update(f.notAvailable());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              margin: EdgeInsets.all(5),
                              width: 10,
                              height: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });

        over.add(Divider());
      }
    }
    if (over.length > 0) {
      over.insert(
          0,
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              "Out of Stock:",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
          ));

      over.insert(1, Divider());
    }
    return over;
  }
}
