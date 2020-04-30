import 'package:campus/screens/usersProfile.dart';
import 'package:campus/services/searchBarService.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'profile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var queryResultSet = [];
  var tempSearchStore = [];
  var _darkTheme;

  initiateSearch(String value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['username'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SafeArea(
      child: Scaffold(
          backgroundColor:_darkTheme ? Colors.black: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // _background(context),
                _searchBar(),
                _searchResults()
              ],
            ),
          )),
    );
  }

  Widget _background(BuildContext _context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: _darkTheme ? Colors.black : Colors.grey[200],
    );
  }

  Widget _searchBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: Builder(
        builder: (BuildContext context) {
          return Card(
            elevation: 5,
                      child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(color: _darkTheme ? Colors.white54 : Colors.white,
                  // borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    new BoxShadow(
                      color: _darkTheme ? Colors.white24 : Colors.black54,
                      blurRadius: 10.0,
                    ),
                  ]),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: _darkTheme ? Colors.black : Colors.black,
                          size: 35,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Container(
                      padding: EdgeInsets.only(top: 12),
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          onChanged: (val) {
                            initiateSearch(val);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search name',
                            hintStyle: TextStyle(
                              color: _darkTheme ? Colors.black : Colors.black45
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _searchResults() {
    return Container(
      child: StaggeredGridView.countBuilder(
          // scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          itemCount: tempSearchStore.length,
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.fit(2),
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          itemBuilder: (BuildContext context, int index) {
            var _item = tempSearchStore[index];
            return GestureDetector(
              onTap: () async {
                final _uid = await Provider.of<AuthenticationState>(context, listen: false)
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
                          transitionDuration: Duration(milliseconds: 400),
                          pageBuilder: (_, __, ___) => UserProfile(
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
                        color: _darkTheme ? Colors.white : Colors.white,
                        child: Image.network(
                          _item['photoUrl'],
                          fit: BoxFit.contain,
                        ),
                      )),
                ),
              ),
            );
          }),
    );
  }
}
