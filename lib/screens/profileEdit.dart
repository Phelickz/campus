import 'package:campus/screens/login.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'editProfile.dart';

enum EditMode { Editing, Adding }

class ProfileEdit extends StatefulWidget {
  final username;
  final bio;
  final emailAddress;
  final phone;
  final EditMode editMode;
  final profileUrl;
  ProfileEdit(
      this.editMode, this.bio, this.emailAddress, this.username, this.phone, this.profileUrl);
  @override
  _ProfileEditState createState() => _ProfileEditState(
      this.editMode, this.bio, this.emailAddress, this.username, this.phone);
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final EditMode editMode;
  final username;
  final bio;
  final emailAddress;
  final phone;
  var _darkTheme;
  // final phone;
  _ProfileEditState(
    this.editMode,
    this.bio,
    this.emailAddress,
    this.username,
    this.phone,
  );

  @override
  void didChangeDependencies() {
    if (widget.editMode == EditMode.Editing) {
      _usernameController.text = username;
      _emailController.text = emailAddress;
      _bioController.text = bio;
      _phoneController.text = phone;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _background(context),
            _backButton(context),
            _submitButton(context),
            _profilePhoto(context),
            _text(context),
            _editForm()
          ],
        ),
      ),
    );
  }

  Widget _background(BuildContext _context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: _darkTheme ? Colors.black : Colors.grey[200],
    );
  }

  Widget _backButton(BuildContext _context) {
    return Positioned(
      top: 20,
      left: 10,
      child: Card(
        elevation: 20,
        shape: CircleBorder(),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: CircleAvatar(
            backgroundColor: _darkTheme ? Colors.white : Colors.black,
            radius: 20,
            child: Icon(Icons.cancel,
                color: _darkTheme ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext _context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.9,
      left: MediaQuery.of(context).size.width * 0.85,
      child: Card(
          elevation: 20,
          shape: CircleBorder(),
          child: InkWell(
            onTap: () {
              _formKey.currentState;
            },
            child: CircleAvatar(
              backgroundColor: _darkTheme ? Colors.white : Colors.black,
              radius: 20,
              child: Icon(
                Icons.done,
                color: _darkTheme ? Colors.black : Colors.white,
              ),
            ),
          )),
    );
  }

  Widget _profilePhoto(BuildContext _context) {
    return Positioned(
      top: 30,
      left: MediaQuery.of(context).size.width * 0.4,
      child: CircleAvatar(
        backgroundImage: NetworkImage(this.widget.profileUrl),
        radius: 40,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _text(BuildContext _context) {
    return Positioned(
      top: 115,
      left: MediaQuery.of(context).size.width * 0.3,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => ImageCapture()));
        },
        child: Text(
          'Change Profile Picture',
          style: TextStyle(
              color: _darkTheme ? Colors.white : Colors.black,
              fontSize: 15,
              fontFamily: 'WorkSansSemiBold'),
        ),
      ),
    );
  }

  Widget _editForm() {
    return Positioned(
        top: 170,
        child: Builder(builder: (BuildContext _context) {
          return Container(
            // color: Colors.blue,
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, top: 30),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Username',
                        style: TextStyle(
                            color: _darkTheme ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            hoverColor: Colors.blue, focusColor: Colors.blue),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Email Address',
                        style: TextStyle(
                            color: _darkTheme ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        validator: EmailValidator.validate,
                        controller: _emailController,
                        decoration: InputDecoration(
                            hoverColor: Colors.blue, focusColor: Colors.blue),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Biography',
                        style: TextStyle(
                            color: _darkTheme ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _bioController,
                        decoration: InputDecoration(
                            hoverColor: Colors.blue, focusColor: Colors.blue),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Phone',
                        style: TextStyle(
                            color: _darkTheme ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                            hoverColor: Colors.blue, focusColor: Colors.blue),
                      ),
                    ],
                  )),
            ),
          );
        }));
  }
}
