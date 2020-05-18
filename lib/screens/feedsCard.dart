import 'package:campus/screens/videoPlayer.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'commentScreen.dart';
import 'profile.dart';
import 'usersProfile.dart';

class FeedCard extends StatefulWidget {
  final _item;
  final newtime;
  FeedCard(this._item, this.newtime);
  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool _liked;
  var _darkTheme;

  @override
  void initState() {
    _restorePersistedPreference();
    super.initState();
  }

  void _restorePersistedPreference() async {
    var preferences = await SharedPreferences.getInstance();
    var liked = preferences.getBool(this.widget._item.documentID) ?? false;
    setState(() => this._liked = liked);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            new BoxShadow(
              color: _darkTheme ? Colors.white24 : Colors.black12,
              blurRadius: 3.0,
            ),
          ]),
      height: 600,
      width: double.infinity,
      child: Card(
        // elevation: _darkTheme ? 20 : 0,
        color: _darkTheme ? Colors.black87 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        final uid = await Provider.of<AuthenticationState>(
                                context,
                                listen: false)
                            .currentUserId();
                        if (this.widget._item.userId == uid) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Profile(uid)));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                      uid,
                                      this.widget._item.userId,
                                      this.widget._item.profilePic,
                                      this.widget._item.username)));
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            _darkTheme ? Colors.white : Colors.white,
                        backgroundImage:
                            NetworkImage(this.widget._item.profilePic),
                        radius: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            this.widget._item.username,
                            style: TextStyle(
                                color: _darkTheme ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: _darkTheme
                                    ? Colors.white54
                                    : Colors.black45,
                              ),
                              Text(
                                this.widget._item.location ?? '',
                                style: TextStyle(
                                  color:
                                      _darkTheme ? Colors.white : Colors.black,
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
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: double.infinity,
                  height: 370,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    elevation: 0,
                    color: this.widget._item.photoUrl == null
                        ? Colors.black
                        : Colors.white,
                    child: this.widget._item.photoUrl != null
                        ? Image.network(
                            this.widget._item.photoUrl,
                            fit: BoxFit.cover,
                          )
                        : FittedBox(
                            fit: BoxFit.contain,
                            child: mounted
                                ? ChewieListItem(
                                    videoPlayerController:
                                        VideoPlayerController.network(
                                            this.widget._item.videoUrl),
                                    looping: false,
                                  )
                                : Container(),
                          ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      this.widget._item.text,
                      style: TextStyle(
                          color: _darkTheme ? Colors.white : Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          fontFamily: 'WorkSansSemiBold'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                _liked == null
                                    ? Icons.favorite_border
                                    : _liked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                color: _liked == null
                                    ? Colors.grey
                                    : _liked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () async {
                                final _auth = Provider.of<AuthenticationState>(
                                    context,
                                    listen: false);
                                final _uid =
                                    await Provider.of<AuthenticationState>(
                                            context,
                                            listen: false)
                                        .currentUserId();
                                await FirebaseAuth.instance
                                    .currentUser()
                                    .then((user) {
                                  setState(() {
                                    _liked = !_liked;
                                    if (_liked) {
                                      _auth.updateLikess(
                                          this.widget._item.documentID);
                                      _auth.postLikes(
                                          _uid,
                                          this.widget._item.documentID,
                                          user.photoUrl,
                                          user.displayName);
                                    } else {
                                      _auth.removeLikesId(
                                          _uid, this.widget._item.documentID);
                                      _auth.reduceLikes(
                                          this.widget._item.documentID);
                                    }
                                  });
                                });
                                var prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool(
                                    this.widget._item.documentID, _liked);
                              },
                            ),
                            Text(
                              '${this.widget._item.likes == null ? 0 : this.widget._item.likes} likes',
                              style: TextStyle(
                                color: _darkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.mode_comment,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 700),
                                      child: CommentScreen(
                                          this.widget._item.username,
                                          this.widget._item.documentID),
                                      type: PageTransitionType.downToUp),
                                );
                              },
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 700),
                                      child: CommentScreen(
                                          this.widget._item.username,
                                          this.widget._item.documentID),
                                      type: PageTransitionType.downToUp),
                                );
                              },
                              child: Text(
                                '${this.widget._item.comments} comments',
                                style: TextStyle(
                                  color:
                                      _darkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.timer,
                                  color: Colors.red,
                                ),
                                onPressed: () {}),
                            Text(
                              '${this.widget.newtime}',
                              style: TextStyle(
                                color: _darkTheme ? Colors.white : Colors.black,
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
  }
}
