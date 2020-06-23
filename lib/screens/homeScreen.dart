import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restobudzz/auth/authentication.dart';
import 'package:restobudzz/models/food.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;
  bool loading = true;
  String activityStatus = "Closed";
  final FirebaseApp app = FirebaseApp(name: "[DEFAULT]");
  FirebaseDatabase db = FirebaseDatabase.instance;
  DatabaseReference itemRef;
  Auth _auth;
  String hotelId;
  List<Food> _food = List();
  Query _foodQuerry;
  StreamSubscription<Event> _onFoodAddedSubscription;
  StreamSubscription<Event> _onFoodChangedSubscription;

  @override
  void initState() {
    super.initState();
    _auth = Auth(context: context);
    print(app.name);
    initFood();
  }

  initFood() async {
    setState(() {
      loading = true;
    });
    hotelId = await _auth.currentUser();
    final FirebaseDatabase _database = FirebaseDatabase(app: app);
    _foodQuerry = await _database
        .reference()
        .child('$hotelId')
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      setState(() {
        isSwitched = snapshot.value["open"];
        if (isSwitched == true)
          activityStatus = "Open";
        else
          activityStatus = "Closed";
      });
    });
    itemRef = _database.reference().child('$hotelId').child("food");
    itemRef.onChildChanged.listen(onEntryChanged);
    itemRef.onChildAdded.listen(onEntryAdded);
    itemRef.onChildRemoved.listen(onEntrydeleted);

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    //_onFoodAddedSubscription.cancel();
    // _onFoodChangedSubscription.cancel();
    super.dispose();
  }

  onEntrydeleted(Event event) {
    setState(() {
      loading = true;
    });
    var oldEntry = _food.singleWhere((entry) {
      return entry.food == event.snapshot.key;
    });

    setState(() {
      // _food[_food.indexOf(oldEntry)] = Food.fromSnapshot(event.snapshot);
      loading = false;
      _food.removeAt(_food.indexOf(oldEntry));
    });
  }

  onEntryChanged(Event event) {
    setState(() {
      loading = true;
    });
    var oldEntry = _food.singleWhere((entry) {
      return entry.food == event.snapshot.key;
    });

    setState(() {
      _food[_food.indexOf(oldEntry)] = Food.fromSnapshot(event.snapshot);
      loading = false;
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      loading = true;
    });
    print(" hooooooooooooooooooooooooooo");
    setState(() {
      _food.add(Food.fromSnapshot(event.snapshot));
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Restobuzz"),
          actions: <Widget>[
            hotelStatus(),
          ],
        ),
        body: loading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SpinKitRipple(
                      color: Colors.black,
                    ),
                  )
                ],
              )
            : _food.isEmpty
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Column(
                        children: <Widget>[
                          //limited items list
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: Center(
                              child: Text(
                                "Manage availability :",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Divider(
                            thickness: 2,
                          ),
                          Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: limitedItems(width),
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding:  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: availableItems(width),
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: overItems(width),
                              ),
                            ),
                          ),
                        ],
                      ),
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
          style: TextStyle(color: isSwitched ? Colors.green : Colors.white),
        ),
        Switch(
          value: isSwitched,
          inactiveTrackColor: Colors.grey,
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
                  Text("${_food[i].food}"),

                  //options
                  Container(
                    width: width / 3.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //availability
                        Column(
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
                                  border:
                                      Border.all(width: 2, color: Colors.green),
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
                                    // color: Colors.grey,
                                  ),
                                  margin: EdgeInsets.all(5),
                                  width: 10,
                                  height: 10,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // limited
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "limited",
                              style: TextStyle(
                                  fontSize: width / 45,
                                  color: Colors.yellow[900]),
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

                        // over
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "over",
                              style: TextStyle(
                                  fontSize: width / 45, color: Colors.red),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.red),
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
                                    // color: Colors.grey,
                                  ),
                                  margin: EdgeInsets.all(5),
                                  width: 10,
                                  height: 10,
                                ),
                              ),
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
                  Text("${_food[i].food}"),

                  //options
                  Container(
                    width: width / 3.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //availability
                        Column(
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
                                  border:
                                      Border.all(width: 2, color: Colors.green),
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

                        // limited
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "limited",
                              style: TextStyle(
                                  fontSize: width / 45,
                                  color: Colors.yellow[900]),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.yellow[800]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                onTap: () {
                                  Food f = Food(price: _food[i].price);
                                  db
                                      .reference()
                                      .child("$hotelId")
                                      .child("food")
                                      .child("${_food[i].food}")
                                      .update(f.setLimited());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.yellow[800],
                                  ),
                                  margin: EdgeInsets.all(5),
                                  width: 10,
                                  height: 10,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // over
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "over",
                              style: TextStyle(
                                  fontSize: width / 45, color: Colors.red),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.red),
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
                                    // color: Colors.grey,
                                  ),
                                  margin: EdgeInsets.all(5),
                                  width: 10,
                                  height: 10,
                                ),
                              ),
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
                  Text("${_food[i].food}"),

                  //options
                  Container(
                    width: width / 3.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //availability
                        Column(
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
                                  border:
                                      Border.all(width: 2, color: Colors.green),
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
                                    //  color: Colors.green,
                                  ),
                                  margin: EdgeInsets.all(5),
                                  width: 10,
                                  height: 10,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // limited
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "limited",
                              style: TextStyle(
                                  fontSize: width / 45,
                                  color: Colors.yellow[900]),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.yellow[800]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                onTap: () {
                                  Food f = Food(price: _food[i].price);
                                  db
                                      .reference()
                                      .child("$hotelId")
                                      .child("food")
                                      .child("${_food[i].food}")
                                      .update(f.setLimited());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.yellow[800],
                                  ),
                                  margin: EdgeInsets.all(5),
                                  width: 10,
                                  height: 10,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // over
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "over",
                              style: TextStyle(
                                  fontSize: width / 45, color: Colors.red),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.red),
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
