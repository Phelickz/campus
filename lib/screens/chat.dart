import 'dart:async';
import 'dart:io';

import 'package:campus/services/model.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'viewPhotoInChat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'viewVideoInChat.dart';

class ChatScreen extends StatefulWidget {
  final String uid;
  final String _conversationID;
  final String _receiverID;
  final String _receiverImage;
  final String _receiverName;
  ChatScreen(this.uid, this._conversationID, this._receiverID,
      this._receiverImage, this._receiverName);
  @override
  _ChatScreenState createState() => _ChatScreenState(
        this.uid,
        this._conversationID,
        this._receiverID,
        this._receiverImage,
        this._receiverName,
      );
}

class _ChatScreenState extends State<ChatScreen> {
  var _darkTheme;
  final String uid;
  final String _conversationID;
  final String _receiverID;
  final String _receiverImage;
  final String _receiverName;

  _ChatScreenState(this.uid, this._conversationID, this._receiverID,
      this._receiverImage, this._receiverName);

  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _messageText;

  // @override
  // void initState() {
  //   super.initState();
  //   messages = getMessages();
  // }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SafeArea(
      child: Scaffold(
          backgroundColor: _darkTheme ? Colors.black : Colors.grey[200],
          body: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              _messageListView(),
              _appBar(context),
              Align(alignment: Alignment.bottomCenter, child: _textEditor())
            ],
          )),
    );
  }

  Widget _textEditor() {
    return Consumer<AuthenticationState>(
      builder: (BuildContext context, _authState, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.18,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
                color: _darkTheme ? Colors.grey[800] : Color(0xffF4F5FA),
                // color: Color(0xffF4F5FA),
                borderRadius: BorderRadius.circular(30)),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      // color: Color(0xffe7e7ef),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: FloatingActionButton(
                      backgroundColor:
                          _darkTheme ? Colors.white24 : Colors.black,
                      child: Icon(Icons.camera),
                      onPressed: () {
                        _modalBottomSheetMenu();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: Validator.validate,
                      // onChanged: (_input) {
                      //   _formKey.currentState.save();
                      // },
                      // onSaved: (_input) {
                      //   setState(() {
                      //     _messageText = _input;
                      //   });
                      // },
                      controller: _messageController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Type your message",
                          hintStyle: TextStyle(
                              color: _darkTheme ? Colors.white54 : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      // color: Color(0xffe7e7ef),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _authState.sendAMessage(
                            this.widget._conversationID,
                            Message(
                              content: _messageController.text,
                              timestamp: Timestamp.now(),
                              senderID: this.widget.uid,
                              type: MessageType.Text,
                            ),
                          );
                          _messageController.clear();
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messageListView() {
    return Consumer<AuthenticationState>(
      builder: (BuildContext context, _authState, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: MediaQuery.of(context).size.height * 0.1,
          ),
          height: MediaQuery.of(context).size.height * 0.92,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<Conversation>(
            stream: _authState.getConversationss(widget._conversationID),
            builder: (context, _snapshot) {
              //scroll chat to bottom automatically when the chat is opened
              Timer(
                Duration(milliseconds: 50),
                () => {
                  if (_scrollController.hasClients)
                    {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent)
                    }
                },
              );
              var _conversationData = _snapshot.data;
              if (_conversationData != null) {
                if (_conversationData.messages != []) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: _conversationData.messages.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var _messages = _conversationData.messages[index];
                      if (_messages.type == MessageType.Text) {
                        return _textMessageBubble(
                            _messages.senderID == widget.uid ? true : false,
                            _messages.content,
                            _messages.timestamp);
                      } else {
                        if (_messages.type == MessageType.Video) {
                          return _videoMessageBubble(
                              _messages.senderID == widget.uid ? true : false,
                              _messages.content,
                              _messages.timestamp);
                        }
                        return _imageMessageBubble(
                            _messages.senderID == widget.uid ? true : false,
                            _messages.content,
                            _messages.timestamp);
                      }
                    },
                  );
                } else {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Start a Conversation',
                      style: TextStyle(color: Colors.black54),
                    ),
                  );
                }
              } else {
                return SpinKitWanderingCubes(
                  color: Colors.blue,
                  size: 50,
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _textMessageBubble(
      bool isByMe, String _message, Timestamp _timestamp) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      alignment: isByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isByMe
                ? _darkTheme ? Color(0xff003300) : Color(0xff483D8B)
                : _darkTheme ? Colors.grey[800] : Color(0xffE6E8EE),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: isByMe ? Radius.circular(30) : Radius.circular(0),
                bottomRight:
                    isByMe ? Radius.circular(0) : Radius.circular(30))),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.08 +
                    (_message.length / 20 * 5.0),
                maxWidth: MediaQuery.of(context).size.width * 2 / 3),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _message,
                  style: TextStyle(
                      color: isByMe
                          ? Color(0xffE0E0E0)
                          : _darkTheme ? Colors.black : Color(0xff650000),
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    timeago.format(_timestamp.toDate()),
                    style: TextStyle(color: Colors.black45),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _imageMessageBubble(
      bool isByMe, String _imageUrl, Timestamp _timestamp) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      alignment: isByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isByMe
                ? _darkTheme ? Color(0xff003300) : Color(0xff00BFFF)
                : _darkTheme ? Color(0xff39573B) : Color(0xffE6E8EE),
            borderRadius: BorderRadius.only(
              // topLeft: Radius.circular(30),
              // topRight: Radius.circular(30),
              bottomLeft: isByMe ? Radius.circular(30) : Radius.circular(0),
            )),
        // bottomRight:
        // isByMe ? Radius.circular(0) : Radius.circular(30))),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) => ViewPhoto(_imageUrl)));
          },
          child: Hero(
            tag: _imageUrl,
            child: Material(
              child: Container(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: MediaQuery.of(context).size.width * 0.60,
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(_imageUrl), fit: BoxFit.cover)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Text(
                      timeago.format(_timestamp.toDate()),
                      style: TextStyle(color: Colors.black87),
                    ),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _videoMessageBubble(
      bool isByMe, String _videoUrl, Timestamp _timestamp) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      alignment: isByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isByMe
                ? _darkTheme ? Color(0xff003300) : Color(0xff00BFFF)
                : _darkTheme ? Color(0xff39573B) : Color(0xffE6E8EE),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            )),
        // bottomLeft: isByMe ? Radius.circular(30) : Radius.circular(0),
        // bottomRight:
        // isByMe ? Radius.circular(0) : Radius.circular(30))),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewVideo(_videoUrl)));
          },
          child: Material(
            child: Container(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    color: Colors.black,
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Icon(
                      FontAwesomeIcons.play,
                      size: 50,
                      color: _darkTheme ? Colors.white : Colors.white,
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    timeago.format(_timestamp.toDate()),
                    style: TextStyle(color: Colors.black87),
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext _context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      color: _darkTheme ? Colors.black : Colors.grey[200],
      child: Stack(
        children: <Widget>[
          _backButton(_context),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.4,
            top: MediaQuery.of(context).size.height * 0.1 / 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: Cro,
              children: <Widget>[
                _photo(),
                _name(_context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _backButton(BuildContext _context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Card(
          elevation: 5,
          shape: CircleBorder(),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: _darkTheme ? Color(0xff39573B) : Colors.white,
              radius: 20,
              child: Icon(Icons.arrow_back_ios,
                  color: _darkTheme ? Colors.black : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _photo() {
    return CircleAvatar(
      backgroundColor: _darkTheme ? Colors.white : Colors.white,
      backgroundImage: NetworkImage(widget._receiverImage),
      radius: 25,
    );
  }

  Widget _name(BuildContext contex) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        widget._receiverName,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _darkTheme ? Colors.white : Colors.black),
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        backgroundColor: _darkTheme? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (builder) {
          final _auth =
              Provider.of<AuthenticationState>(context, listen: false);
          return new Container(
            padding: EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height * 0.2,
            // color: Color(0xFF737373), //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(
                    Icons.photo,
                    color: _darkTheme? Colors.white: Colors.black,
                  ),
                  title: new Text(
                    'Share Photo',
                    style: TextStyle(color: _darkTheme? Colors.white: Colors.black,),
                  ),
                  onTap: () async {
                    File _image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (_image != null) {
                      _auth.sendAPhoto(
                        this.widget.uid,
                        _image,
                        this.widget._conversationID,
                        Message(
                            senderID: this.widget.uid,
                            timestamp: Timestamp.now(),
                            type: MessageType.Image),
                      );
                    }
                  },
                ),
                new ListTile(
                  leading: new Icon(
                    Icons.videocam,
                    color: _darkTheme? Colors.white: Colors.black,
                  ),
                  title: new Text(
                    'Share Video',
                    style: TextStyle(color: _darkTheme? Colors.white: Colors.black,),
                  ),
                  onTap: () async {
                    File _video = await ImagePicker.pickVideo(
                        source: ImageSource.gallery);
                    if (_video != null) {
                      _auth.sendAVideo(
                        this.widget.uid,
                        _video,
                        this.widget._conversationID,
                        Message(
                            senderID: this.widget.uid,
                            timestamp: Timestamp.now(),
                            type: MessageType.Video),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  // void _showDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         final _auth =
  //             Provider.of<AuthenticationState>(context, listen: false);
  //         return Padding(
  //           padding: const EdgeInsets.all(0.0),
  //           child: AlertDialog(
  //             title: Text(
  //               'Select',
  //               style: TextStyle(
  //                   fontFamily: 'WorkSansSemiBold',
  //                   fontSize: 25,
  //                   color: Colors.black),
  //             ),
  //             content: Container(
  //               height: 65,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   InkWell(
  //                     child: Text(
  //                       'Share Photo',
  //                       style: TextStyle(
  //                           fontSize: 20, fontFamily: 'WorkSansSemiBold'),
  //                     ),
  //                     onTap: () async {
  //                       File _image = await ImagePicker.pickImage(
  //                           source: ImageSource.gallery);
  //                       if (_image != null) {
  //                         _auth.sendAPhoto(
  //                           this.widget.uid,
  //                           _image,
  //                           this.widget._conversationID,
  //                           Message(
  //                               senderID: this.widget.uid,
  //                               timestamp: Timestamp.now(),
  //                               type: MessageType.Image),
  //                         );
  //                       }
  //                     },
  //                   ),
  //                   SizedBox(height: 15),
  //                   InkWell(
  //                     child: Text(
  //                       'Share Video',
  //                       style: TextStyle(
  //                           fontSize: 20, fontFamily: 'WorkSansSemiBold'),
  //                     ),
  //                     onTap: () async {
  //                       File _video = await ImagePicker.pickVideo(
  //                           source: ImageSource.gallery);
  //                       if (_video != null) {
  //                         _auth.sendAVideo(
  //                           this.widget.uid,
  //                           _video,
  //                           this.widget._conversationID,
  //                           Message(
  //                               senderID: this.widget.uid,
  //                               timestamp: Timestamp.now(),
  //                               type: MessageType.Video),
  //                         );
  //                       }
  //                     },
  //                   )
  //                 ],
  //               ),
  //             ),
  //             actions: <Widget>[
  //               FlatButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Close'))
  //             ],
  //           ),
  //         );
  //       });
  // }
}

class Validator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Field cannot be empty";
    }

    return null;
  }
}
