import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseOperations {
  BuildContext context;
  FirebaseOperations({this.context});
  FirebaseDatabase db = FirebaseDatabase.instance;

  addHotelDetails({@required hotelId, @required restaurantName,@required email,@required phone}) {
    db.reference().child("$hotelId").set({
      "name": "$restaurantName",
      "email": "$email",
      "phone": "$phone",
      "open": false
    });
  }
}
