import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restobudzz/auth/authentication.dart';
import 'package:restobudzz/screens/home.dart';
import 'package:restobudzz/screens/homeScreenNavigator.dart';
import 'package:restobudzz/screens/signup.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Auth _auth;
  bool tapped=false;
  @override
  void initState() {
    _auth = Auth(context: context);
    // _auth.signUp("email", "password");
    //_auth.signInWithEmailAndPassword("email", "password");
   // _auth.currentUser();
    //_auth.signOut();
    super.initState();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Login"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: ListView(
             
              children: <Widget>[
                Container(
                //  margin: EdgeInsets.only(top: 80),
                 // height: MediaQuery.of(context).size.width / 2.5,
                  // child: Image.asset(
                  //   "assets/images/TCRWA.png",
                  // ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Welcome to Restobuzz!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: width / 16,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 12,
                      right: MediaQuery.of(context).size.width / 12,
                      top: 30),
                  child: TextField(
                    controller: email,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String email) {},
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'email',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 12,
                      right: MediaQuery.of(context).size.width / 12,
                      top: 16,
                      bottom: 20),
                  child: TextField(
                    obscureText: true,
                    controller: password,
                    keyboardType: TextInputType.text,
                    onChanged: (String email) {},
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'password',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                  ),
                ),
                  !tapped?  InkWell(
                  onTap: () async{
                    setState(() {
                      tapped=true;
                    });
                    bool response =await _auth.signInWithEmailAndPassword(
                        "${email.text}", "${password.text}");
                        print(response);
                    if (response == true) {
                     // print(response.asStream);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomeScreenNavigator()));
                    } else {
                      setState(() {
                        tapped=false;
                      });
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              title: Text(
                                'Invalid details',
                                style: TextStyle(color: Color(0xff3a3a3a)),
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  elevation: 5.0,
                                  child: Text("ok"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 12),
                    height: MediaQuery.of(context).size.width / 7,
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 18),
                      ),
                    ),
                  ),
                ):SpinKitWave(
                  color: Colors.black,
                  size: 40,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ForgotPassord(),
                        //   ),
                        // );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: MediaQuery.of(context).size.width / 25),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 20, horizontal: width / 4),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signup() ));
                      },
                      child: Container(
                        child: Text(
                          " Signup",
                          style: TextStyle(
                              color: Colors.blue[400],
                              fontSize: MediaQuery.of(context).size.width / 25),
                        ),
                      ),
                    ),
                  ),
                ),

                // Container(
                //   padding: EdgeInsets.all(10),
                //   height: 200,
                //   width: width,
                //   child:Image.asset("assets/images/rest.jpg",fit: BoxFit.cover,) ,
                // )


              ],
            ),
          ),
        ));
  }
}
