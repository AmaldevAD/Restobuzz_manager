import 'package:firebase_database/firebase_database.dart';

class Food {
  String food;
  bool available;
  bool limited;
  var price;
  String description;
  String imageUrl;

  Food({this.food, this.available, this.limited, this.price, this.description,this.imageUrl});

  Food.fromSnapshot(DataSnapshot snapshot)
      : food = snapshot.key,
        available = snapshot.value["available"],
        limited = snapshot.value["limited"],
        description=snapshot.value["description"],
        imageUrl=snapshot.value["imageUrl"],
        price = snapshot.value["price"];

  toJson() {
    return { "available": false, "limited": false,"price":price,"description":description,"imageUrl":imageUrl};
  }

  setAvailable() {
    return { "available": true, "limited": false,"price":price};
  }

  notAvailable() {
    return { "available": false, "limited": false,"price":price};
  }

  setLimited() {
    return { "available": false, "limited": true,"price":price};
  }
}
