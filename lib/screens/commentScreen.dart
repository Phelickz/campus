import 'package:campus/services/model.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatefulWidget {
  final _username;
  final _postId;
  CommentScreen(this._username, this._postId);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  var _darkTheme;
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  String _messageText;
  String _displayName;
  String _photoUrl;
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Comments"),
          ),
          backgroundColor: _darkTheme ? Colors.black : Colors.grey[200],
          body: Stack(
            children: <Widget>[_commentListView(), _textField()],
          )),
    );
  }

  Widget _commentListView() {
    return Builder(builder: (BuildContext _context) {
      final _authState = Provider.of<AuthenticationState>(_context);

      return Container(
          color: _darkTheme ? Colors.black : Colors.grey[200],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: StreamBuilder<List<Comments>>(
              stream: _authState.getComments(this.widget._postId),
              builder: (_context, _snapshot) {
                return _snapshot.hasData
                    ? _snapshot.data.isNotEmpty
                        ? ListView.builder(
                            itemCount: _snapshot.data.length,
                            itemBuilder: (BuildContext _context, int index) {
                              return ListTile(
                                trailing: Text(timeago.format(
                                    _snapshot.data[index].timestamp.toDate())),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      _snapshot.data[index].photoUrl),
                                ),
                                title: Text(_snapshot.data[index].userId),
                                subtitle: Text(_snapshot.data[index].message),
                              );
                            },
                          )
                        : Center(
                            child: Text('Be the first to comment'),
                          )
                    : CircularProgressIndicator();
              }));
    });
  }

  Widget _textField() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Builder(builder: (BuildContext _context) {
          final _authState = Provider.of<AuthenticationState>(_context);
          return Container(
            color: _darkTheme ? Colors.black : Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 10, right: 20),
              child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          validator: Validator.validate,
                          // onChanged: (_input) {
                          //   _formKey.currentState.save();
                          // },
                          // onSaved: (_input) {
                          //   setState(() {
                          //     _messageText = _input;
                          //   });
                          // },
                          controller: _commentController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type your comment'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          await FirebaseAuth.instance
                              .currentUser()
                              .then((user) {
                            setState(() {
                              _displayName = user.displayName;
                              _photoUrl = user.photoUrl;
                            });
                          });
                          if (_formKey.currentState.validate()) {
                            _authState.postComments(
                                this.widget._postId,
                                _displayName,
                                _photoUrl,
                                Comments(
                                  message: _commentController.text,
                                  timestamp: Timestamp.now(),
                                ));
                            _commentController.clear();
                            FocusScope.of(context).unfocus();
                          }
                        },
                      )
                    ],
                  )),
            ),
          );
        }));
  }
}


class Validator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Field cannot be empty";
    }

    return null;
  }
}