import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restobudzz/models/hotel.dart';
import 'package:restobudzz/screens/userViewFood.dart';

class UserView extends StatefulWidget {
  UserView({Key key}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  StreamSubscription<Event> _onFoodAddedSubscription;
  StreamSubscription<Event> _onFoodChangedSubscription;
  final FirebaseApp app = FirebaseApp(
    name: "[DEFAULT]",
  );

  DatabaseReference itemRef;
  List<Hotel> _hotel = List();
  List<String> keys=List();


   @override
  void initState() {
    super.initState();
    print(app.name);
    initHotel();
  }

  initHotel() async {
    final FirebaseDatabase _database = FirebaseDatabase(app: app);
   

    itemRef = _database.reference();
    itemRef.onChildChanged.listen(onEntryChanged);
    itemRef.onChildAdded.listen(onEntryAdded);
    itemRef.onChildRemoved.listen(onEntrydeleted);
  }

   onEntrydeleted(Event event) {
    print(" hooooooooooooooooooooooooooo");
    var oldEntry = _hotel.singleWhere((entry) {
      return entry.hotelId == event.snapshot.key;
    });

    setState(() {
      // _food[_food.indexOf(oldEntry)] = Food.fromSnapshot(event.snapshot);
      _hotel.removeAt(_hotel.indexOf(oldEntry));
      keys.add(event.snapshot.key);
    });
  }

  onEntryChanged(Event event) {
    print(" hooooooooooooooooooooooooooo");
    var oldEntry = _hotel.singleWhere((entry) {
      return entry.hotelId == event.snapshot.key;
    });

    setState(() {
      _hotel[_hotel.indexOf(oldEntry)] = Hotel.fromSnapshot(event.snapshot);
      keys.add(event.snapshot.key);
    });
  }

  onEntryAdded(Event event) {
    print(" hooooooooooooooooooooooooooo");
    print(event.snapshot.key);
    setState(() {
      _hotel.add(Hotel.fromSnapshot(event.snapshot));
      keys.add(event.snapshot.key);
    });
  }

  @override
  Widget build(BuildContext context) {
   // print();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Restaurants"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _hotel.length,
  
              itemBuilder: (context, i) {
                print(keys[i]);
                print(_hotel[i].toJson());
                return _hotel[i].open==true?
                Container(
                  child: InkWell(
                    onTap: (){
                      print("keys[i]${keys[i]}");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserViewFood(keys[i])));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.domain),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_hotel[i].name,style: TextStyle(fontSize: 18,color: Colors.grey[600]),),
                                    Text("Open", style: TextStyle(color: Colors.green),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                         Divider(height: 0,color: Colors.black, )
                      ],
                    ),
                  ),
                ):SizedBox();
              },
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _hotel.length,

              itemBuilder: (context, i) {
                return _hotel[i].open==false?
                Container(
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        color: Colors.grey[200],
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.domain),
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_hotel[i].name,style: TextStyle(fontSize: 18,color: Colors.grey[600]),),
                                  Text("Closed", style: TextStyle(color: Colors.red),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                       Divider(height: 0,color: Colors.black, )
                    ],
                  ),
                ):SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
