import 'package:firebase_database/firebase_database.dart';
import 'package:restobudzz/models/food.dart';

class Hotel {
  String name;
  String email;
  bool open;
  String phone;
  Food food;
  String hotelId;

  Hotel({this.name, this.email, this.open, this.phone,this.food, this.hotelId});

  Hotel.fromSnapshot(DataSnapshot snapshot)
      : food = snapshot.value["food"],
        name = snapshot.value["name"],
        open = snapshot.value["open"],
        phone = snapshot.value["phone"],
        hotelId=snapshot.key;

  toJson() {
    return { "name": name, "email": email,"open":open,"phone": phone,};
  }

}
