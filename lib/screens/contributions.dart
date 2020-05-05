import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/authstate.dart';
import '../services/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../screens/profile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../screens/viewPhotoInChat.dart';

class ContributionScreen extends StatefulWidget {
  final _topicId;
  final _topic;
  ContributionScreen(this._topicId, this._topic);
  @override
  _ContributionScreenState createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget._topic),
      ),
      body: Stack(
        children: <Widget>[
          _contributionsListView(),
          _textField(),
        ],
      ),
    );
  }

  Widget _contributionsListView() {
    return Builder(builder: (BuildContext _context) {
      final _authState = Provider.of<AuthenticationState>(_context);

      return Container(
          // color: _darkTheme ? Colors.black : Colors.grey[200],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: StreamBuilder<List<Contributions>>(
              stream: _authState.getContributions(this.widget._topicId),
              builder: (_context, _snapshot) {
                return _snapshot.hasData
                    ? _snapshot.data.isNotEmpty
                        ? ListView.builder(
                            itemCount: _snapshot.data.length,
                            itemBuilder: (BuildContext _context, int index) {
                              return Card(
                                  child: ListTile(
                                trailing: Text(
                                  timeago.format(
                                    _snapshot.data[index].timestamp.toDate(),
                                  ),
                                ),
                                leading: InkWell(
                                  onTap: () async {
                                    final _uid =
                                        await Provider.of<AuthenticationState>(
                                                context)
                                            .currentUserId();

                                    if (_uid == _snapshot.data[index].userId) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Profile(_uid)));
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        _snapshot.data[index].profilePic),
                                  ),
                                ),
                                title: Text(_snapshot.data[index].username),
                                subtitle: _snapshot.data[index].photoUrl == null
                                    ? Text(_snapshot.data[index].message)
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 400),
                                                  pageBuilder: (_, __, ___) =>
                                                      ViewPhoto(_snapshot.data[index].photoUrl)));
                                        },
                                        child: Hero(
                                          tag: _snapshot.data[index].photoUrl,
                                          child: Material(
                                            child: Image.network(
                                                _snapshot.data[index].photoUrl),
                                          ),
                                        ),
                                      ),
                              ));
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
            // color: _darkTheme ? Colors.black : Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 10, right: 20),
              child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.photo_camera,
                          size: 20,
                        ),
                        onPressed: () async {
                          File _image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (_image != null) {
                            await FirebaseAuth.instance
                                .currentUser()
                                .then((user) {
                              _authState.addCommunityTopicComment(
                                  this.widget._topicId,
                                  Contributions(
                                      message: null,
                                      timestamp: Timestamp.now()),
                                  user.uid,
                                  user.photoUrl,
                                  user.displayName,
                                  _image);
                            });
                          }
                        },
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          validator: Validator.validate,
                          // onChanged: (_input) {},
                          // onSaved: (_input) {},
                          controller: _messageController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type your comment'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            await FirebaseAuth.instance
                                .currentUser()
                                .then((user) {
                              _authState.addCommunityTopicComment(
                                  this.widget._topicId,
                                  Contributions(
                                      message: _messageController.text,
                                      timestamp: Timestamp.now()),
                                  user.uid,
                                  user.photoUrl,
                                  user.displayName,
                                  null);
                              _messageController.clear();
                              FocusScope.of(context).unfocus();
                            });
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
