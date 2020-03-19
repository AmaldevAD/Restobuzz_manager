import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restobudzz/models/food.dart';
import 'dart:async';
import 'dart:convert';



 final FirebaseApp app= FirebaseApp(
   name: "[DEFAULT]",
);
FirebaseDatabase db=FirebaseDatabase.instance;



DatabaseReference itemRef;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Food> _food = List();

 
  Query _foodQuerry;
  String hotelId = "hotelid";
  StreamSubscription<Event> _onFoodAddedSubscription;
  StreamSubscription<Event> _onFoodChangedSubscription;

  @override
  void initState() {
    super.initState();
    print(app.name);
    initFood();
  }

  initFood() async {
      final FirebaseDatabase _database = FirebaseDatabase(app:app);
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

    itemRef=_database.reference().child('$hotelId').child("food");
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


  inputItem() async{
    Food f= Food(price: 25);
    db.reference().child("$hotelId").child("food").child("manga").set(f.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: <Widget>[

          Column(
            
          ),



          Container(
            height: 300,
            child: ListView.builder(
                itemCount: _food.length,
                itemBuilder: (context, int i) {
                  return Text("${_food[i].food}");
                }),
          ),

          IconButton(icon: Icon(Icons.add), onPressed: (){
            inputItem();
          })
        ],
      ),
    );
  }
}
