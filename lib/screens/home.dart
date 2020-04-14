import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restobudzz/models/food.dart';
import 'dart:async';
import 'package:restobudzz/auth/authentication.dart';
import 'package:restobudzz/screens/login.dart';

final FirebaseApp app = FirebaseApp(
  name: "[DEFAULT]",
);
FirebaseDatabase db = FirebaseDatabase.instance;

DatabaseReference itemRef;
Auth _auth;
String hotelId;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    hotelId = await _auth.currentUser();
    final FirebaseDatabase _database = FirebaseDatabase(app: app);
    _foodQuerry = await _database
        .reference()
        .child('$hotelId')
        .child("food")
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      // Map<dynamic, dynamic> map = snapshot.value;

      // snapshot.value.forEach((childSnapshot) {
      //   //var childKey = childSnapshot.key;
      //   //var childData = childSnapshot.val();
      //  // print(childKey);
      // });

      // print(snapshot.value["maggi"]);
      // for(int i=0;i<snapshot.value.length;i++){
      //   _food.add(Food.fromSnapshot(snapshot.value["maggi"]));
      // }

      //print(_food[0].available);
      // print(snapshot.value);
      // _food.add(Food.fromSnapshot(map[0]));
    });
    // _onFoodAddedSubscription = _foodQuerry.onChildAdded.listen(onEntryAdded);
    //  _onFoodChangedSubscription=_foodQuerry.onChildChanged.listen(onEntryChanged);

    //print(_food[0].available);

    itemRef = _database.reference().child('$hotelId').child("food");
    itemRef.onChildChanged.listen(onEntryChanged);
    itemRef.onChildAdded.listen(onEntryAdded);
    itemRef.onChildRemoved.listen(onEntrydeleted);
  }

  @override
  void dispose() {
    _onFoodAddedSubscription.cancel();
    _onFoodChangedSubscription.cancel();
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

  inputItem() async {
    Food f = Food(price: 25);
    db
        .reference()
        .child("$hotelId")
        .child("food")
        .child("manga")
        .set(f.toJson());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
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

            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  inputItem();
                }),
            IconButton(
                icon: Icon(Icons.golf_course),
                onPressed: () async{
                 await _auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                    (r) => false,
                  );
                })
          ],
        ),
      ),
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
                                      .set(f.setAvailable());
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
                                      .set(f.notAvailable());
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
                  fontSize: width / 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600),
            ),
          ));

      limited.insert(1, Divider());
    }
    return limited;
  }

  //available
  //available List
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
                                      .set(f.setAvailable());
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
                                      .set(f.setLimited());
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
                                      .set(f.notAvailable());
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
                  fontSize: width / 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600),
            ),
          ));

      available.insert(1, Divider());
    }
    return available;
  }

  //

  //available
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
                                      .set(f.setAvailable());
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
                                      .set(f.setLimited());
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
                                      .set(f.notAvailable());
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
                  fontSize: width / 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600),
            ),
          ));

      over.insert(1, Divider());
    }
    return over;
  }
}
