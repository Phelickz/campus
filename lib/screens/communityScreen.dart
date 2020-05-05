import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/description.dart';
import 'matchscreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/cupertino.dart';
import '../screens/contributions.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  var _darkTheme;
  Color _colors = Colors.black;
  Color _background = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthenticationState>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MatchScreen()));
                    },
                    child: CircleAvatar(
                      backgroundColor: _background,
                      radius: 20,
                      child: Icon(
                        Icons.people,
                        color: Colors.black,
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
                          color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: _darkTheme ? Colors.amber : Colors.red,
          child: Icon(Icons.add_circle),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Description()));
          }),
      appBar: AppBar(
        title: Text('Community Trends'),
        centerTitle: true,
      ),
      backgroundColor: _darkTheme ? Colors.black : Colors.grey[300],
      body: StreamBuilder<List<Topic>>(
        stream: _auth.getTopics(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var _item = snapshot.data[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ContributionScreen(
                                    _item.documentID, _item.topic)));
                      },
                      child: Container(
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text(
                              _item.topic,
                              style: TextStyle(
                                  fontFamily: 'WorkSansSemiBold', fontSize: 20),
                            ),
                            subtitle: Text(_item.category),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(_item.contributions.toString() +
                                    ' contributions'),
                                Text(timeago.format(_item.timestamp.toDate()))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator();
        },
      ),
    );
  }
}
