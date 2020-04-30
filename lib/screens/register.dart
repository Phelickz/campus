import 'package:campus/services/snackbarService.dart';
import 'package:campus/state/authstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../utilities.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeUsername = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscureTextSignup = true;
  // bool _obscureTextSignupConfirm = true;

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();

    super.dispose();
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _background(context),
            _signUp(),
            _backButton(context)
          ],
        ),
      ),
    );
  }

  Widget _background(BuildContext _context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(_context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/SignUpImage.png'),
              fit: BoxFit.cover)),
    );
  }

  Widget _backButton(BuildContext context) {
    return Positioned(
        top: 10,
        left: 10,
        child: Card(
          elevation: 10,
          shape: CircleBorder(),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[800],
              radius: 20,
              child: Icon(Icons.arrow_back, color: Colors.red),
            ),
          ),
        ));
  }

  Widget _signUp() {
    return Builder(builder: (BuildContext _context) {
      SnackBarService.instance.buildContext = _context;
      return Positioned(
          top: 110.0,
          bottom: 20.0,
          left: 10.0,
          right: 10.0,
          child: Container(
              // color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Create Your Account',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSansBold'),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            // width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))),
                            child: TextFormField(
                              validator: PasswordValidator.validate,
                              focusNode: myFocusNodeUsername,
                              controller: _usernameController,
                              // obscureText: _obscureTextSignup,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                                icon: Icon(
                                  FontAwesomeIcons.userAlt,
                                  size: 22.0,
                                  color: Colors.black,
                                ),
                                hintText: "Username",
                                hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            // width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))),
                            child: TextFormField(
                              validator: EmailValidator.validate,
                              focusNode: myFocusNodeEmail,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                icon: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.black,
                                    size: 22.0,
                                  ),
                                ),
                                hintText: "Email Address",
                                hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 15.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            // width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))),
                            child: TextFormField(
                              validator: PhoneValidator.validate,
                              focusNode: myFocusNodePhone,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                icon: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    FontAwesomeIcons.phone,
                                    color: Colors.black,
                                    size: 22.0,
                                  ),
                                ),
                                hintText: "Phone Number",
                                hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 15.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            // width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))),
                            child: TextFormField(
                              validator: PasswordValidator.validate,
                              focusNode: myFocusNodePassword,
                              controller: _passwordController,
                              obscureText: _obscureTextSignup,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                                icon: Icon(
                                  FontAwesomeIcons.lock,
                                  size: 22.0,
                                  color: Colors.black,
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignup,
                                  child: Icon(
                                    _obscureTextSignup
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35))),
                            child: MaterialButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.green,
                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 42.0),
                                  child: Text(
                                    "CREATE",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 25.0,
                                        fontFamily: "WorkSansBold"),
                                  ),
                                ),
                                onPressed: () {
                                  final form = _formKey.currentState;
                                  form.save();
                                  if (form.validate()) {
                                    try {
                                      Provider.of<AuthenticationState>(context,
                                              listen: false)
                                          .signup(

                                              _emailController.text,
                                              _passwordController.text,
                                              _usernameController.text,
                                              _phoneController.text)
                                          .then((signInUser) =>
                                              gotoHomeScreen(context));
                                      // gotoHomeScreen(context);
                                      // print('signed up');
                                      // Navigator.push(context,
                                      //   MaterialPageRoute(builder: (context) => Feedss()));
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                }
                                // onPressed: () =>
                                //     showInSnackBar("Login button pressed")),
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Align(
                              child: Text(
                                'Or create using',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, right: 40.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    child: new Icon(
                                      FontAwesomeIcons.facebookF,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: new Icon(
                                      FontAwesomeIcons.google,
                                      color: Color(0xFF0084ff),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              )));
    });
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email cannot be empty";
    }
    return null;
  }
}

class UsernameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Username cannot be empty";
    }
    if (value.length < 2) {
      return "Username is too short";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password cannot be empty";
    }
    return null;
  }
}

class PhoneValidator{
  static String validate(String value){
    if (value.length < 10) {
      return "Please enter a valid number";
    }
    return null;
  }
}