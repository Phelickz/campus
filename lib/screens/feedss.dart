import 'package:campus/screens/chatscreen.dart';
import 'package:campus/screens/feedsCard.dart';
import 'package:campus/screens/matchscreen.dart';
import 'package:campus/screens/profile.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/userState.dart';
import 'package:campus/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool _liked;
  String likedKey;

  List<bool> _isLiked;

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
    _restorePersistedPreference();
    super.initState();
  }

  void _restorePersistedPreference() async {
    var preferences = await SharedPreferences.getInstance();
    var liked = preferences.getBool('uniqque') ?? false;
    setState(() => this._liked = liked);
  }

  void _persistPreference() async {
    setState(() => _liked = !_liked);
    var preferences = await SharedPreferences.getInstance();
    preferences.setBool(likedKey, _liked);
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
            SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: _darkTheme ? Colors.black : Colors.white54,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 24),
                                  color: _darkTheme
                                      ? Colors.black
                                      : Colors.white54,
                                  height: 160,
                                  width: MediaQuery.of(context).size.width,
                                  // color: Colo,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: userNotifier.usersPosts.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        var _feed =
                                            userNotifier.usersPosts[index];
                                        if (userNotifier
                                            .usersPosts.isNotEmpty) {
                                          return InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 55),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      _feed.photoUrl ??
                                                          _feed.profilePic),
                                                  radius: 37,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return CircularProgressIndicator();
                                      }),
                                ),
                                StreamBuilder<List<Post>>(
                                    stream: auth.getPosts(),
                                    builder: (context, snapshot) {
                                      var _data = snapshot.data;
                                      return snapshot.hasData
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: _data.length,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var _item = _data[index];
                                                final time = DateTime.now();
                                                final postTime =
                                                    _data[index].date;
                                                final difference =
                                                    time.difference(postTime);
                                                var newtime = timeago.format(
                                                    time.subtract(difference),
                                                    locale: 'en');
                                                return FeedCard(_item, newtime);
                                              })
                                          : CircularProgressIndicator();
                                    }),
                              ],
                            ),
                          )),
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
