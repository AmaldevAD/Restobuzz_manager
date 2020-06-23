import 'package:flutter/material.dart';
import 'package:restobudzz/screens/account.dart';
import 'package:restobudzz/screens/itemsScreen.dart';
import 'package:restobudzz/screens/userView.dart';
import './homeScreen.dart';

class HomeScreenNavigator extends StatefulWidget {
  HomeScreenNavigator({Key key}) : super(key: key);

  @override
  _HomeScreenNavigatorState createState() => _HomeScreenNavigatorState();
}

class _HomeScreenNavigatorState extends State<HomeScreenNavigator> {
  int _selectedIndex = 0;

  loadNavigationContent() {
    print(_selectedIndex);
    switch (_selectedIndex) {
      case 0:
        {
          return HomeScreen();
        }
        break;
      case 1:
        {
          return ItemsScreen();
        }
        break;
      case 2:
        {
          return UserView();
        }
        case 3:
        {
          return Account();
        }
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadNavigationContent(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20),
            title: Text(
              'HOME',
              style: TextStyle(fontSize: 12),
            ),
          ),
           BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              size: 20,
            ),
            title: Text(
              'Items',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_remote,
              size: 20,
            ),
            title: Text(
              'User View',
              style: TextStyle(fontSize: 12),
            ),
          ),
         
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 20,
            ),
            title: Text(
              'Account',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
