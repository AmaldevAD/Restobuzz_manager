import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restobudzz/auth/authentication.dart';
import 'package:restobudzz/firebaseOperations/firebaseOperations.dart';
import 'package:restobudzz/screens/homeScreenNavigator.dart';
import 'package:restobudzz/screens/login.dart';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Auth _auth;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool tapped = false;
  FirebaseOperations _firebaseOperations;
  @override
  void initState() {
    _auth = Auth(context: context);
    _firebaseOperations = FirebaseOperations(context: context);
    super.initState();
  }

  signUpFunction() async {
    print("validated");
    bool response = await _auth.signUp(
        email: _emailController.text, password: _passwordController.text);
    print(response);
    if (response == true) {
      String hoteId = await _auth.currentUser();
      _firebaseOperations.addHotelDetails(
          email: _emailController.text,
          hotelId: hoteId,
          restaurantName: _nameController.text,
          phone: _phoneController.text);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreenNavigator()));
    }
    setState(() {
      tapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Signup"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: <Widget>[
                  //restuarent name
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name of restaurant',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'Name is required';
                        } else {
                          _nameController.text = _nameController.text.trim();
                          return null;
                        }
                      },
                    ),
                  ),
                  //email
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'Enter Valid Email';
                        } else {
                          _emailController.text =
                              _emailController.text.trim().toLowerCase();
                          return null;
                        }
                      },
                    ),
                  ),

                  //phone
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextFormField(
                      maxLength: 10,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: "",
                        labelText: 'phone',
                      ),
                      validator: (String value) {
                        if (_phoneController.text.trim().length < 10) {
                          return 'Enter valid phone';
                        } else {
                          _phoneController.text = _phoneController.text.trim();
                          return null;
                        }
                      },
                    ),
                  ),

                  //password
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'Enter valid password';
                        } else {
                          _passwordController.text =
                              _passwordController.text.trim();
                          return null;
                        }
                      },
                    ),
                  ),
                  //confirm password
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'confirm password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String value) {
                        if (value.trim() != _passwordController.text.trim()) {
                          return 'Password did not match ';
                        }
                        return null;
                      },
                    ),
                  ),

                  //button
                  !tapped
                      ? InkWell(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: width / 12, vertical: 20),
                            height: width / 7,
                            color: Colors.black,
                            child: Center(
                              child: Text(
                                "Signup",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 18),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              tapped = true;
                            });
                            if (_formKey.currentState.validate()) {
                              signUpFunction();
                            }
                            else{
                               setState(() {
                              tapped = false;
                            });
                            }


                          },
                        )
                      : Container(
                        margin: EdgeInsets.only(top:18),
                        child: SpinKitWave(
                            color: Colors.black,
                            size: 40,
                          ),
                      ),

                  InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width / 12, vertical: 20),
                      child: Center(
                        child: Text(
                          "Already user? Login",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: MediaQuery.of(context).size.width / 28),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
