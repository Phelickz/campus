import 'package:campus/screens/communityScreen.dart';
import 'package:campus/screens/profile.dart';
import 'package:campus/screens/usersProfile.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  var _darkTheme;
  Color _colors = Colors.black;
  Color _background = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SafeArea(
          child: Scaffold(
        backgroundColor: _darkTheme ? Colors.black : Colors.grey[100],
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
                            MaterialPageRoute(builder: (context) => MatchScreen()));
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(
                          Icons.people,
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
                                builder: (context) => CommunityScreen()));
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(FontAwesomeIcons.peopleCarry,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: _darkTheme ? Colors.black : Colors.white,
          title: Text(
            'Discover People',
            style: TextStyle(color: _darkTheme ? Colors.white : Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: _darkTheme ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: _darkTheme ? Colors.white : Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => Search()));
              },
            ),
          ],
        ),
        body: _usersDataList(),
      ),
    );
  }

  Widget _usersDataList() {
    return Builder(builder: (BuildContext _context) {
      final auth = Provider.of<AuthenticationState>(_context);
      return Container(
        child: StreamBuilder(
            stream: getData(_context),
            builder: (_context, snapshot) {
              return snapshot.hasData
                  ? new StaggeredGridView.countBuilder(
                      // scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      itemCount: snapshot.data.documents.length,
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, index.isEven ? 2 : 1),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemBuilder: (BuildContext context, int index) {
                        var _data = snapshot.data.documents;

                        var _item = _data[index];
                        return GestureDetector(
                          onTap: () async {
                            final _uid = await Provider.of<AuthenticationState>(
                                    context,
                                    listen: false)
                                .currentUserId();
                            if (_uid == _item['uid']) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Profile(_uid)));
                            } else {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 400),
                                      pageBuilder: (_, __, ___) => UserProfile(
                                          _uid,
                                          _item['uid'],
                                          _item['photoUrl'],
                                          _item['username'])));
                            }
                          },
                          child: Hero(
                            tag: _item['uid'],
                            child: Material(
                              child: Container(
                                  color: Colors.transparent,
                                  child: Card(
                                    elevation: 5,
                                    color: _darkTheme
                                        ? Colors.white
                                        : Colors.white,
                                    child: Image.network(
                                      _item['photoUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                          ),
                        );
                      })
                  : SpinKitWanderingCubes(color: Colors.red);
            }),
      );
    });
  }

  Stream<QuerySnapshot> getData(BuildContext context) async* {
    yield* Firestore.instance
        .collection('userData')
        .orderBy('createdAt')
        .snapshots();
  }
}
