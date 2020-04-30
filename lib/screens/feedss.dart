import 'package:campus/screens/chatscreen.dart';
import 'package:campus/screens/commentScreen.dart';
import 'package:campus/screens/matchscreen.dart';
// import 'package:campus/screens/post.dart';
import 'package:campus/screens/profile.dart';
import 'package:campus/screens/usersProfile.dart';

import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/userState.dart';
import 'package:campus/utilities.dart';
import 'package:campus/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:campus/services/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:campus/services/model.dart';
import 'package:campus/state/authstate.dart';

import 'settings.dart';

class Feedss extends StatefulWidget {
  //  final String uid;

  //  Feedss(this.uid);
  @override
  _FeedssState createState() => _FeedssState();
}

class _FeedssState extends State<Feedss> {
  var _darkTheme;
  int counter;
  // List<bool> _liked;
  bool _liked = false;

  Color _colors = Colors.black;
  Color _background = Colors.grey[200];

  // int _favoriteCount;
  //  final String uid;
  // _FeedssState(this.uid);

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUsersPosts(userNotifier);
    getUsersFeeds(userNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    final auth = Provider.of<AuthenticationState>(context);
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.blue[300],
        bottomNavigationBar: BottomAppBar(
          color: _darkTheme ? Colors.black : Colors.grey[200],

          // color: Colors.red,
          shape: CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white38 : Colors.black38,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    // elevation: _darkTheme ? 40 : 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Feedss()));
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(
                          Icons.home,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white54 : Colors.black38,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    // elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () async {
                        final user = await Provider.of<AuthenticationState>(
                                context,
                                listen: false)
                            .currentUserId();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(user)));
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(FontAwesomeIcons.userAstronaut,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white38 : Colors.black38,

                          // color: _darkTheme ? Colors.white : Colors.black,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () async {
                        final _uid = await Provider.of<AuthenticationState>(
                                context,
                                listen: false)
                            .currentUserId();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => Home(_uid)));
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(Icons.chat_bubble, color: _colors),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white38 : Colors.black38,

                          // color: _darkTheme ? Colors.white : Colors.black,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child:
                            Icon(Icons.notification_important, color: _colors),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white38 : Colors.black38,

                          // color: _darkTheme ? Colors.white : Colors.black,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(Icons.settings, color: _colors),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _backgroundImage(context),

            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: _darkTheme ? Colors.black : Colors.white54,
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      // color: Colo,
                      child: Container(
                        height: 120,
                        // width: double.infinity,
                        color: Colors.transparent,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: userNotifier.usersPosts.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, index) {
                              var _feed = userNotifier.usersPosts[index];
                              if (userNotifier.usersPosts.isNotEmpty) {
                                return InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 55),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(_feed.photoUrl),
                                        radius: 37,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            }),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            color: _darkTheme ? Colors.black : Colors.white54,
                            child: StreamBuilder<List<Post>>(
                                stream: auth.getPosts(),
                                builder: (context, snapshot) {
                                  var _data = snapshot.data;
                                  return snapshot.hasData
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _data.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var _item = _data[index];
                                            final time = DateTime.now();
                                            final postTime = _data[index].date;
                                            final difference =
                                                time.difference(postTime);
                                            var newtime = timeago.format(
                                                time.subtract(difference),
                                                locale: 'en');
                                            return Container(
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: _darkTheme
                                                          ? Colors.white24
                                                          : Colors.black12,
                                                      blurRadius: 3.0,
                                                    ),
                                                  ]),
                                              height: 600,
                                              width: double.infinity,
                                              child: Card(
                                                // elevation: _darkTheme ? 20 : 0,
                                                color: _darkTheme
                                                    ? Colors.black87
                                                    : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                top: 10),
                                                        child: Row(
                                                          children: <Widget>[
                                                            InkWell(
                                                              onTap: () async {
                                                                final uid = await Provider.of<
                                                                            AuthenticationState>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .currentUserId();
                                                                if (_data[index]
                                                                        .userId ==
                                                                    uid) {
                                                                  Navigator.push(
                                                                      context,
                                                                      CupertinoPageRoute(
                                                                          builder: (context) =>
                                                                              Profile(uid)));
                                                                } else {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => UserProfile(
                                                                              _item.userId,
                                                                              _item.profilePic,
                                                                              _item.username)));
                                                                }
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    _darkTheme
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .white,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        _item
                                                                            .profilePic),
                                                                radius: 30,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    _data[index]
                                                                        .username,
                                                                    style: TextStyle(
                                                                        color: _darkTheme
                                                                            ? Colors
                                                                                .white
                                                                            : Colors
                                                                                .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .location_on,
                                                                        color: _darkTheme
                                                                            ? Colors.white54
                                                                            : Colors.black45,
                                                                      ),
                                                                      Text(
                                                                        'Benin City',
                                                                        style:
                                                                            TextStyle(
                                                                          color: _darkTheme
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),

                                                      // decoration: BoxDecoration(
                                                      //   color: Colors.red,
                                                      //   borderRadius: BorderRadius.circular(20)
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 370,
                                                          child: Card(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0)),
                                                            elevation: 0,
                                                            color: Colors.white,
                                                            child: _item.photoUrl !=
                                                                    null
                                                                ? Image.network(
                                                                    _item
                                                                        .photoUrl,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Container(),
                                                          ),
                                                        ),
                                                      ),

                                                      SizedBox(height: 10),
                                                      Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15),
                                                            child: Text(
                                                              _item.text,
                                                              style: TextStyle(
                                                                  color: _darkTheme
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black87,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  fontFamily:
                                                                      'WorkSansSemiBold'),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    right: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          _liked
                                                                              ? Icons.favorite
                                                                              : Icons.favorite_border,
                                                                          color: _liked
                                                                              ? Colors.red
                                                                              : Colors.grey,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          final _auth = Provider.of<AuthenticationState>(
                                                                              context,
                                                                              listen: false);
                                                                          final _uid = await Provider.of<AuthenticationState>(context, listen: false).currentUserId();
                                                                          
                                                                          final FirebaseUser _user = await Provider.of<AuthenticationState>(context, listen: false).getCurrentUser();
                                                                          // _liked  = await getLiked();

                                                                          setState(
                                                                              () {
                                                                            _liked =
                                                                                !_liked;

                                                                            counter =
                                                                                _item.likes;

                                                                            // counter++;
                                                                            if (_liked) {
                                                                              counter = counter + 2;
                                                                              // setLiked(true);
                                                                              _auth.updateLikess(_item.documentID);
                                                                              _auth.postLikes(_uid, _item.documentID, _user.photoUrl);
                                                                            } else {
                                                                              counter = counter + 1;
                                                                              // setLiked(false);
                                                                              _auth.removeLikesId(_uid, _item.documentID);
                                                                              _auth.reduceLikes(_item.documentID);
                                                                            }
                                                                          });
                                                                        }),
                                                                    Text(
                                                                      '${_item.likes == null ? 0 : _item.likes} likes',
                                                                      style:
                                                                          TextStyle(
                                                                        color: _darkTheme
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .mode_comment,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          PageTransition(
                                                                              duration: Duration(milliseconds: 400),
                                                                              child: CommentScreen(_item.username, _item.documentID),
                                                                              type: PageTransitionType.downToUp),
                                                                        );
                                                                      },
                                                                    ),
                                                                    Text(
                                                                      '${_item.comments} comments',
                                                                      style:
                                                                          TextStyle(
                                                                        color: _darkTheme
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .timer,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        onPressed:
                                                                            () {}),
                                                                    Text(
                                                                      '${newtime}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: _darkTheme
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          })
                                      : CircularProgressIndicator();
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            _button(context),

            //
          ],

          // ListView(
          //   children: <Widget>[
          //     Text('data'),
          //     Text('data')
          //   ],
          // )
        ),
      ),
    );
  }

  Widget _backgroundImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[200],
    );
  }

  Widget _button(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          color: Colors.transparent,
          height: 50,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: 50,
              width: 100,
              color: Colors.transparent,
              child: RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 65),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.fire,
                          color: Colors.red,
                        ),
                        Text(
                          'Discover People!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                        Icon(
                          FontAwesomeIcons.fire,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MatchScreen()));
                  }),
            ),
          )),
    );
  }
}
