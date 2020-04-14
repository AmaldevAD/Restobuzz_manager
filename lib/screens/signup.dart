import 'package:flutter/material.dart';
import 'package:restobudzz/auth/authentication.dart';
import 'package:restobudzz/screens/home.dart';

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

  @override
  void initState() {
    _auth = Auth(context: context);
    super.initState();
  }

  signUpFunction() async {
    print("validated");
    bool response = await _auth.signUp(email: _emailController.text,password: _passwordController.text );
    print(response);
    if (response == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
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
          title: Text("Signup"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                //restuarent name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name of restaurant',
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
                //email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(
                    labelText: 'Email',
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

                //phone
                TextFormField(
                  maxLength: 10,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
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

                //password
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'password',
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
                //confirm password
                TextFormField(
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'confirm password',
                  ),
                  validator: (String value) {
                    if (value.trim() != _passwordController.text.trim()) {
                      return 'Password did not match ';
                    }
                    return null;
                  },
                ),

                //button
                InkWell(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width / 12, vertical: 20),
                    height: width / 7,
                    color: Colors.blue[400],
                    child: Center(
                      child: Text(
                        "Signup",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 18),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      signUpFunction();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
