import 'package:campus/services/model.dart';
import 'package:campus/state/authstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final _username;
  final _postId;
  CommentScreen(this._username, this._postId);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _messageText;
  String _displayName;
  String _photoUrl;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("${this.widget._username}'s comments"),
          ),
          backgroundColor: Colors.grey[200],
          body: Stack(
            children: <Widget>[_commentListView(), _textField()],
          )),
    );
  }

  Widget _commentListView() {
    return Builder(builder: (BuildContext _context) {
      final _authState = Provider.of<AuthenticationState>(_context);

      return Container(
          color: Colors.grey[200],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: StreamBuilder<List<Comments>>(
              stream: _authState.getComments(this.widget._postId),
              builder: (_context, _snapshot){
                return _snapshot.hasData ? 
                  ListView.builder(
                    itemCount: _snapshot.data.length,
                    itemBuilder: (BuildContext _context, int index){
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(_snapshot.data[index].photoUrl),

                        ),
                        title: Text(_snapshot.data[index].userId),
                        subtitle: Text(_snapshot.data[index].message),
                      );
                    },): Center(child: Text('Be the first to comment'),);
              }));
    });
  }

  Widget _textField() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Builder(builder: (BuildContext _context) {
          final _authState = Provider.of<AuthenticationState>(_context);
          return Container(
            color: Colors.white,
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
                          validator: (_input) {
                            if (_input.length == 0) {
                              return 'Please Enter a message';
                            }
                            return null;
                          },
                          onChanged: (_input) {
                            _formKey.currentState.save();
                          },
                          onSaved: (_input) {
                            setState(() {
                              _messageText = _input;
                            });
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type your comment'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async{
                          await FirebaseAuth.instance.currentUser().then((user){
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
                                  message: _messageText,
                                  timestamp: Timestamp.now(),
                                ));
                            _formKey.currentState.reset();
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
