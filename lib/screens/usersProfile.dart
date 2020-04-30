import 'package:campus/screens/chat.dart';
import 'package:campus/services/firestore.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/state/userState.dart';
import 'package:campus/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final _profileUrl;
  final _uid;
  final _username;
  UserProfile(this._uid, this._profileUrl, this._username);
  @override
  _UserProfileState createState() =>
      _UserProfileState(this._uid, this._profileUrl, this._username);
}

class _UserProfileState extends State<UserProfile> {
  final _uid;
  final _profileUrl;
  final _username;
  var _darkTheme;
  _UserProfileState(this._uid, this._profileUrl, this._username);

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUsersData(userNotifier, _uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          _background(context),
          _pictureContainer(),
          _usersDataContainer(),
          _usersDataContinued(),
          _messageButton(),
          _backButton(context)
        ],
      ),
    );
  }

  Widget _background(BuildContext _context) {
    return Container(
      height: MediaQuery.of(_context).size.height,
      width: MediaQuery.of(_context).size.width,
      color: _darkTheme ? Colors.black : Colors.white,
    );
  }

  Widget _pictureContainer() {
    return Positioned(
      child: Builder(builder: (BuildContext _context) {
        return Hero(
          tag: _uid,
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(image: NetworkImage(_profileUrl))),
            ),
          ),
        );
      }),
    );
  }

  Widget _usersDataContainer() {
    return Positioned(
        top: MediaQuery.of(context).size.height * 0.48,
        left: MediaQuery.of(context).size.width * 0.11,
        child: Builder(builder: (BuildContext _context) {
          UserNotifier _userNotifier = Provider.of<UserNotifier>(context);

          return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: _userNotifier.userProfileData.length,
                itemBuilder: (BuildContext context, int index) {
                  var _item = _userNotifier.userProfileData[index];

                  return Container(
                    decoration: BoxDecoration(
                        // color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.45,
                    child: Card(
                      color: _darkTheme ? Colors.grey[800] : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(_item.username,
                                        style: TextStyle(
                                            color: _darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 30,
                                            fontFamily: 'WorkSansSemiBold')),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Card(
                                        elevation: 10,
                                        shape: CircleBorder(),
                                        child: InkWell(
                                          onTap: () {},
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 20,
                                            child: Icon(Icons.add,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 5),
                              child: Text(_item.bio,
                                  style: TextStyle(
                                      color: _darkTheme
                                          ? Colors.white54
                                          : Colors.black54,

                                      // color: Colors.black54,
                                      fontSize: 17)),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        }));
  }

  Widget _usersDataContinued() {
    return Positioned(
        top: MediaQuery.of(context).size.height * 0.68,
        left: MediaQuery.of(context).size.width * 0.19,
        child: Builder(builder: (BuildContext _context) {
          UserNotifier _userNotifier = Provider.of<UserNotifier>(context);

          return Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: StreamBuilder(
                stream: getData(context),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            var _item = snapshot.data.documents[index];

                            return Container(
                              // col
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.width * 0.3,
                              child: Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              _item['posts'].toString(),
                                              style: TextStyle(
                                                  color: _darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Posts',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: _darkTheme
                                                    ? Colors.white38
                                                    : Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              _item['followers'].toString(),
                                              style: TextStyle(
                                                  color: _darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('Followers',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: _darkTheme
                                                      ? Colors.white38
                                                      : Colors.black54,
                                                ))
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              _item['following'].toString(),
                                              style: TextStyle(
                                                  color: _darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('Following',
                                                style: TextStyle(
                                                    color: _darkTheme
                                                        ? Colors.white38
                                                        : Colors.black54,
                                                    fontSize: 20))
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          })
                      : SpinKitWanderingCubes(
                          color: Colors.blue,
                        );
                }),
          );
        }));
  }

  Widget _messageButton() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.9,
      left: MediaQuery.of(context).size.width * 0.15,
      child: Builder(builder: (BuildContext context) {
        final _auth = Provider.of<AuthenticationState>(context, listen: false);
        return Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              // color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Card(
            color: Colors.red,
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: MaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.green,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "MESSAGE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
              onPressed: () async {
                final _currentID = await _auth.currentUserId();
                _auth.createNewMessage(_currentID, this.widget._uid,
                    (String _conversationID) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ChatScreen(
                            _currentID,
                            _conversationID,
                            this.widget._uid,
                            this.widget._profileUrl,
                            this.widget._username)),
                  );
                });
              },
              // onPressed: () =>
              //     showInSnackBar("Login button pressed")),
            ),
          ),
        );
      }),
    );
  }

  Widget _backButton(BuildContext context) {
    return Positioned(
      top: 20,
      left: 10,
      child: Card(
        elevation: 10,
        shape: CircleBorder(),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getData(BuildContext context) async* {
    yield* Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: _uid)
        .snapshots();
  }
}
