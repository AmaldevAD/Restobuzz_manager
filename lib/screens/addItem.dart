import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restobudzz/models/food.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:restobudzz/auth/authentication.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseDatabase db = FirebaseDatabase.instance;
  Auth _auth;
  bool tapped = false;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  String hotelId;
  String imageUrl = "";

  @override
  void initState() {
    _auth = Auth(context: context);
    super.initState();
    getDetails();
  }

  getDetails() async {
    hotelId = await _auth.currentUser();
  }

  inputItem() async {
    Food f = Food(
        price: double.tryParse(price.text),
        description: description.text,
        imageUrl: imageUrl);
    await db
        .reference()
        .child("$hotelId")
        .child("food")
        .child("${name.text}")
        .set(f.toJson());

    setState(() {
      name.clear();
      description.clear();
      price.clear();
      imageUrl = "";
      tapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Item"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  //keyboardType: TextInputType.phone,c
                  // autovalidate: true,
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String value) {
                    if (value.length < 1) {
                      return "Required field";
                    }
                    return null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  constraints: BoxConstraints(minHeight: 100),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3)),
                  child: TextField(
                    //controller: _description,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: description,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      //enabledBorder: OutlineInputBorder(),
                      hintText: "Description",
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                    showCursor: true,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    // autovalidate: true,
                    controller: price,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(),
                      labelText: '₹₹',
                    ),
                    validator: (String value) {
                      if (value.length < 1) {
                        return "Required field";
                      } else if (double.tryParse(value) <= 0) {
                        return "Enter valid amount";
                      }
                    },
                  ),
                ),

                //savle
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: !tapped
                        ? InkWell(
                            onTap: () async {
                              setState(() {
                                tapped = true;
                              });
                              if (_formKey.currentState.validate()) {
                                await inputItem();
                                homeScaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Item added",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.black,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                setState(() {
                                  tapped = false;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              color: Colors.black,
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : SpinKitWave(
                            color: Colors.black,
                            size: 35,
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
