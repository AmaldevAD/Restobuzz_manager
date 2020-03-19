import 'package:firebase_database/firebase_database.dart';

class Food {
  String food;
  bool available;
  bool limited;
  var price;

  Food({this.food, this.available, this.limited, this.price});

  Food.fromSnapshot(DataSnapshot snapshot)
      : food = snapshot.key,
        available = snapshot.value["available"],
        limited = snapshot.value["limited"],
        price = snapshot.value["price"];

  toJson() {
    return { "available": false, "limited": false,"price":price};
  }

  setAvailable() {
    return { "available": true, "limited": false};
  }

  notAvailable() {
    return { "available": false, "limited": false};
  }

  setLimited() {
    return { "available": false, "limited": true};
  }
}
