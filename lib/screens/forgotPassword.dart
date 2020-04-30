import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus/screens/login_page.dart';
import 'package:campus/services/snackbarService.dart';
import 'package:campus/state/authstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _error;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          showAlert(),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                        "assets/images/shutterstock_remember_password.jpg")),
                color: Colors.white),
            height: 210,
            width: double.infinity,
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10),
                  child: Text(
                    'Enter the email address associated with your account',
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                SizedBox(height: 50),
                // Padding(
                //   padding: const EdgeInsets.only(left: 30),
                //   child: Text('Email',
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold
                //     ),),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 10),
                  child: TextFormField(
                    validator: EmailValidator.validate,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Email Address',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 270),
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.transparent,
                    child: RaisedButton(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          final form = formKey.currentState;
                          form.save();
                          if (form.validate()) {
                            try {
                              _error =
                                  'A reset password link has been sent to ${emailController.text}';
                              setState(() {
                                _error = _error;
                              });
                              Provider.of<AuthenticationState>(context,
                                      listen: false)
                                  .forgotPassword(emailController.text);
                              // Navigator.push(context,
                              // MaterialPageRoute(builder: (context) => ForgotPassword()));
                            } catch (e) {
                              print(e);
                            }
                          }
                        }),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.green,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
                child: AutoSizeText(
              _error,
              maxLines: 3,
            )),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _error = null;
                    });
                  }),
            )
          ],
        ),
      );
    }
    return Container(
        height: 0,
        width: double.infinity,
        color: Colors.red,
        child: SizedBox(height: 20));
  }
}
