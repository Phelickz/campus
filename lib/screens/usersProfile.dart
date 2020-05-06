import 'package:campus/screens/chat.dart';
import 'package:campus/screens/followersList.dart';
import 'package:campus/services/firestore.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/state/userState.dart';
import 'package:campus/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'followingList.dart';
import 'viewUserProfilePosts.dart';

class UserProfile extends StatefulWidget {
  final _currentUser;
  final _profileUrl;
  final _uid;
  final _username;
  UserProfile(this._currentUser, this._uid, this._profileUrl, this._username);
  @override
  _UserProfileState createState() =>
      _UserProfileState(this._uid, this._profileUrl, this._username);
}

class _UserProfileState extends State<UserProfile> {
  final _uid;
  static String uid;
  final _profileUrl;
  final _username;
  var _darkTheme;
  bool _isFollowing;
  _UserProfileState(this._uid, this._profileUrl, this._username);

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUsersData(userNotifier, _uid);
    docSnapshot();
    super.initState();
  }

  Future<void> docSnapshot() async {
    setState(() {
      uid = this.widget._uid;
    });
    var something =
        await Firestore.instance.collection('userData').document(uid).get();
    DocumentSnapshot doc = something;
    if (doc['followersList'].contains(this.widget._currentUser)) {
      setState(() {
        _isFollowing = true;
      });
    } else {
      setState(() {
        _isFollowing = false;
      });
    }
    print(doc);
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
      child: Builder(
        builder: (BuildContext _context) {
          final _auth = Provider.of<AuthenticationState>(context);

          return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: StreamBuilder(
              stream: getData(_context),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          var _item = snapshot.data.documents[index];

                          return Container(
                            decoration: BoxDecoration(
                                // color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.45,
                            child: Card(
                              color:
                                  _darkTheme ? Colors.grey[800] : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(_item['username'],
                                                style: TextStyle(
                                                    color: _darkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 30,
                                                    fontFamily:
                                                        'WorkSansSemiBold')),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: Card(
                                                elevation: 10,
                                                shape: CircleBorder(),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      _isFollowing == null
                                                          ? Colors.black
                                                          : _isFollowing
                                                              ? Colors.green
                                                              : Colors.black,
                                                  radius: 20,
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          _isFollowing =
                                                              !_isFollowing;
                                                        });

                                                        if (_isFollowing) {
                                                          await FirebaseAuth
                                                              .instance
                                                              .currentUser()
                                                              .then((user) {
                                                            _auth.follow(
                                                                this
                                                                    .widget
                                                                    ._uid,
                                                                user.photoUrl,
                                                                user.uid,
                                                                user
                                                                    .displayName,
                                                                _item[
                                                                    'username']);

                                                            Scaffold.of(context)
                                                                .showSnackBar(SnackBar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    content: Text(
                                                                        'You now follow ${this.widget._username}')));
                                                          });
                                                        } else {
                                                          await FirebaseAuth
                                                              .instance
                                                              .currentUser()
                                                              .then((user) {
                                                            _auth.unFollowUser(
                                                                this
                                                                    .widget
                                                                    ._uid,
                                                                user.photoUrl,
                                                                user.uid,
                                                                user.displayName);

                                                            Scaffold.of(context)
                                                                .showSnackBar(SnackBar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    content: Text(
                                                                        'You unfollowed ${this.widget._username}')));
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(
                                                          _isFollowing == null
                                                              ? Icons.person_add
                                                              : _isFollowing
                                                                  ? Icons.done
                                                                  : Icons.person_add,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 5),
                                      child: Text(_item['bio'],
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
                        },
                      )
                    : CircularProgressIndicator();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _usersDataContinued() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.68,
      left: MediaQuery.of(context).size.width * 0.19,
      child: Builder(
        builder: (BuildContext _context) {
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
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewUserPosts(
                                                            _item['uid'])));
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                _item['posts'].toString(),
                                                style: TextStyle(
                                                    color: _darkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FollowersList(
                                                            this.widget._uid)));
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                _item['followersList']
                                                    .length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: _darkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FollowingList(
                                                            this.widget._uid)));
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                _item['followingList']
                                                    .length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: _darkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text('Following',
                                                  style: TextStyle(
                                                      color: _darkTheme
                                                          ? Colors.white38
                                                          : Colors.black54,
                                                      fontSize: 20))
                                            ],
                                          ),
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
        },
      ),
    );
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
                if (_isFollowing == true) {
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
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                          'You must follow ${this.widget._username} to send a message')));
                }
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
