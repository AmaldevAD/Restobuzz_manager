import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class FirebaseOperations {
  BuildContext context;
  FirebaseOperations({this.context});
  FirebaseDatabase db = FirebaseDatabase.instance;


  addHotelDetails(hotelId){
    db
        .reference()
        .child("$hotelId")
        .set("");
  }
}
