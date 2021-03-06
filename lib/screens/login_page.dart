
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus/screens/forgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:campus/style/theme.dart' as Theme;
import 'package:campus/utils/bubble_indicator.dart';
import 'package:provider/provider.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utilities.dart';
import 'package:campus/services/snackbarService.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  final formKey = GlobalKey<FormState>();
  String _error;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeUsername = FocusNode();
  final FocusNode myFocusNodeLastName = FocusNode();
  final FocusNode myFocusNodeBusinessName = FocusNode();
  final FocusNode myFocusNodeBusinessDescription = FocusNode();
  final FocusNode myFocusNodeLocation = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupUsernameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();
  TextEditingController signupPhoneController = new TextEditingController();
  TextEditingController signupBusinessNameController = new TextEditingController();
  TextEditingController signupBusinessDescriptionController = new TextEditingController();
  TextEditingController signupLocationController = new TextEditingController();
  

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    
    return Consumer<AuthenticationState>(
      builder: (builder, authState, child){
        return new Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height >= 775.0
                      ? MediaQuery.of(context).size.height
                      : 775.0,
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientStart,
                          Theme.Colors.loginGradientEnd
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 5),
                      showAlert(),
                      Padding(
                        padding: EdgeInsets.only(top: 75.0),
                        child: new Image(
                            width: 250.0,
                            height: 191.0,
                            fit: BoxFit.fill,
                            image: new AssetImage('assets/images/login_logo.png')),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: _buildMenuBar(context),
                      ),
                      Expanded(
                        flex: 2,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (i) {
                            if (i == 0) {
                              setState(() {
                                right = Colors.white;
                                left = Colors.black;
                              });
                            } else if (i == 1) {
                              setState(() {
                                right = Colors.black;
                                left = Colors.white;
                              });
                            }
                          },
                          children: <Widget>[
                            new ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: _buildSignIn(),
                            ),
                            new ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: _buildSignUp(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      );
  }
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeUsername.dispose();
    myFocusNodeLastName.dispose();
    myFocusNodeBusinessName.dispose();
    myFocusNodeBusinessDescription.dispose();
    myFocusNodeLocation.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn() {
    return Builder(
      builder: (BuildContext context){
        return Container(
        padding: EdgeInsets.only(top: 23.0),
        child: Form(
        // key: formKey,
            child: SingleChildScrollView(
                        child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Card(
                        elevation: 2.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
              width: 300.0,
              height: 190.0,
              child: SingleChildScrollView(
                          child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                      child: TextFormField(
                        validator: EmailValidator.validate,
                        focusNode: myFocusNodeEmailLogin,
                        controller: loginEmailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.black,
                            size: 22.0,
                          ),
                          hintText: "Email Address",
                          hintStyle: TextStyle(
                            color: Colors.black,
                              fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        ),
                      ),
                    ),
                    Container(
                      width: 250.0,
                      height: 1.0,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                      child: TextFormField(
                        validator: PasswordValidator.validate,
                        focusNode: myFocusNodePasswordLogin,
                        controller: loginPasswordController,
                        obscureText: _obscureTextLogin,
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.lock,
                            size: 22.0,
                            color: Colors.black,
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.black,
                              fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          suffixIcon: GestureDetector(
                            onTap: _toggleLogin,
                            child: Icon(
                              _obscureTextLogin
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 170.0),
                        decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.Colors.loginGradientStart,
                  offset: Offset(1.0, 6.0),
                  blurRadius: 20.0,
                ),
                BoxShadow(
                  color: Theme.Colors.loginGradientEnd,
                  offset: Offset(1.0, 6.0),
                  blurRadius: 20.0,
                ),
              ],
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientEnd,
                    Theme.Colors.loginGradientStart
                  ],
                  begin: const FractionalOffset(0.2, 0.2),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
                        ),
                        child: MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: Theme.Colors.loginGradientEnd,
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: "WorkSansBold"),
                  ),
                ),
                 onPressed: (){
                   final form = formKey.currentState;
                  form.save();
                  if (form.validate()) {
                   try {
                    Provider.of<AuthenticationState>(context, listen: false).login(
                      
                      loginEmailController.text, 
                      loginPasswordController.text);
                      gotoHomeScreen(context);
                      // Navigator.push(context, 
                      //   MaterialPageRoute(builder: (context) => Feedss()));
                   } catch (e) {
                     print(e);
                     setState(() {
                       _error = e.message;
                       print(_error);
                     });
                     
                    }
                 }
                      
                  },
                // onPressed: () =>
                //     showInSnackBar("Login button pressed")),
                      ))
                        ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: FlatButton(
                        onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => ForgotPassword()));
                    },
                        child: Text(
              "Forgot Password?",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "WorkSansMedium"),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Colors.white10,
                      Colors.white,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              width: 100.0,
              height: 1.0,
                        ),
                        Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                "Or",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "WorkSansMedium"),
              ),
                        ),
                        Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white10,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              width: 100.0,
              height: 1.0,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, right: 40.0),
                        child: GestureDetector(
              onTap: () => showInSnackBar("Facebook button pressed"),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: new Icon(
                  FontAwesomeIcons.facebookF,
                  color: Color(0xFF0084ff),
                ),
              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: GestureDetector(
              onTap: () => showInSnackBar("Google button pressed"),
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
                ],
          ),
            ),
        ),
      );}
    );
  }

  Widget _buildSignUp() {
    return Builder(
      builder: (BuildContext context){
       SnackBarService.instance.buildContext = context;

        return Container(
        padding: EdgeInsets.only(top: 23.0),
        child: Form(
            key: formKey,
            child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: 300.0,
                      height: 290.0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                              child: TextFormField(
                                validator: UsernameValidator.validate,
                                focusNode: myFocusNodeUsername,
                                controller: signupUsernameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.black,
                                  ),
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                      fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                                      
                                ),
                              ),
                            ),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                              child: TextFormField(
                                validator: EmailValidator.validate,
                                focusNode: myFocusNodeEmail,
                                controller: signupEmailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.black,
                                  ),
                                  hintText: "Email Address",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                      fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                                      
                                ),
                              ),
                            ),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                              child: TextFormField(
                                validator: PasswordValidator.validate,
                                focusNode: myFocusNodePassword,
                                controller: signupPasswordController,
                                obscureText: _obscureTextSignup,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                      fontFamily: "WorkSansSemiBold", fontSize: 16.0),
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
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                              child: TextField(
                                controller: signupConfirmPasswordController,
                                obscureText: _obscureTextSignupConfirm,
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: "Confirmation",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                      fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleSignupConfirm,
                                    child: Icon(
                                      _obscureTextSignupConfirm
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 270.0),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Theme.Colors.loginGradientStart,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: Theme.Colors.loginGradientEnd,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: new LinearGradient(
                          colors: [
                            Theme.Colors.loginGradientEnd,
                            Theme.Colors.loginGradientStart
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontFamily: "WorkSansBold"),
                          ),
                        ),
                        onPressed: (){
                          final form = formKey.currentState;
                          form.save();
                          if (form.validate()) {
                           try {
                            Provider.of<AuthenticationState>(context, listen: false).signup(
                              
                              signupEmailController.text, 
                              signupPasswordController.text,
                              signupUsernameController.text,
                              signupPhoneController.text).then((signInUser)=> gotoHomeScreen(context));
                              // gotoHomeScreen(context);
                              // print('signed up');
                              // Navigator.push(context, 
                              //   MaterialPageRoute(builder: (context) => Feedss()));
                           } catch (e) {
                             print(e);
                            }
                        }
                  
                          }),
                  ),
                ],
              ),
            ],
          ),
        ),
      );}
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  Widget showAlert(){
    if (_error != null) {
      return Container(
        color: Colors.blue,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
              ),
              Expanded(child: AutoSizeText(_error, maxLines: 3,)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(Icons.close), 
                  onPressed: (){
                    setState(() {
                      _error = null;
                    });
                  }),)
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }
}



class EmailValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return "Email cannot be empty";
    }
    return null;
  }
}

class UsernameValidator {
  static String validate(String value) {
    if(value.isEmpty) {
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
    if(value.isEmpty) {
      return "Password cannot be empty";
    }
    return null;
  }
}