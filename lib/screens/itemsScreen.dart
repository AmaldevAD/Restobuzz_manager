import 'package:flutter/material.dart';
import 'package:restobudzz/screens/addItem.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restobudzz/auth/authentication.dart';
import 'package:restobudzz/models/food.dart';

class ItemsScreen extends StatefulWidget {
  ItemsScreen({Key key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  StreamSubscription<Event> _onFoodAddedSubscription;
  StreamSubscription<Event> _onFoodChangedSubscription;
  final FirebaseApp app = FirebaseApp(
    name: "[DEFAULT]",
  );
  FirebaseDatabase db = FirebaseDatabase.instance;

  List<Food> _food = List();
  String hotelId;
  var newPrice;

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

    itemRef = _database.reference().child('$hotelId').child("food");
    itemRef.onChildChanged.listen(onEntryChanged);
    itemRef.onChildAdded.listen(onEntryAdded);
    itemRef.onChildRemoved.listen(onEntrydeleted);
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

  DatabaseReference itemRef;
  Auth _auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Items"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddItem()));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(20, 20, 10, 80),
        itemCount: _food.length,
        separatorBuilder: (context, i) {
          return Divider();
        },
        addRepaintBoundaries: true,
        itemBuilder: (context, i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
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
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {
                        return showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: MediaQuery.of(context).viewInsets,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          // autovalidate: true,
                                          autofocus: true,
                                          onChanged: (value){
                                            setState(() {
                                             newPrice= double.tryParse(value);
                                            });
                                          },
                                          // controller: price,
                                          decoration: const InputDecoration(
                                            counterText: "",
                                            //border: OutlineInputBorder(),
                                            labelText: 'Enter new price',
                                          
                                          ),
                                          validator: (String value) {
                                            if (value.length < 1) {
                                              return "Required field";
                                            } else if (double.tryParse(value) <=
                                                0) {
                                              return "Enter valid amount";
                                            }
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 25),
                                        child: InkWell(
                                            onTap: () async {
                                             await db
                                                  .reference()
                                                  .child('$hotelId')
                                                  .child("food")
                                                  .child(_food[i].food).update({'price':newPrice});
                                                  Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child:
                          Icon(Icons.edit, size: 21, color: Colors.grey[700]),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15),
                      child: GestureDetector(
                        onTap: () {
                          print("object");
                          db
                              .reference()
                              .child('$hotelId')
                              .child("food")
                              .child(_food[i].food)
                              .remove()
                              .then((_) {});
                        },
                        child: Icon(
                          Icons.delete,
                          size: 21,
                          color: Colors.grey[700],
                        ),
                      )),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
