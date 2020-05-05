import 'package:campus/screens/profile.dart';
import 'package:campus/screens/usersProfile.dart';
import 'package:campus/services/model.dart';
import 'package:campus/state/authstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowingList extends StatefulWidget {
  final uid;
  FollowingList(this.uid);
  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthenticationState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: StreamBuilder<List<Followers>>(
          stream: _auth.getFollowing(this.widget.uid),
          builder: (context, _snapshot) {
            var _data = _snapshot.data;
            return _snapshot.hasData
                ? ListView.builder(
                    itemCount: _data.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                            final _uid =
                                await Provider.of<AuthenticationState>(context, listen: false)
                                    .currentUserId();
                            if (_uid == _data[index].uid) {
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
                                          _data[index].uid,
                                          _data[index].photoUrl,
                                          _data[index].username)));
                            }
                          },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(_data[index].photoUrl),
                          ),
                          title: Text(_data[index].username),
                        ),
                      );
                    })
                : CircularProgressIndicator();
          }),
    );
  }
}
