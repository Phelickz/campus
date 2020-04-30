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

class ChatScreen extends StatefulWidget {
  var _darkTheme;
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
                      onPressed: () async {
                        File _image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (_image != null) {
                          _authState.sendAPhoto(
                              this.widget.uid,
                              _image,
                              this.widget._conversationID,
                              Message(
                                  senderID: this.widget.uid,
                                  timestamp: Timestamp.now(),
                                  type: MessageType.Image));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
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
                      // controller: _messageController,
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
                              content: _messageText,
                              timestamp: Timestamp.now(),
                              senderID: this.widget.uid,
                              type: MessageType.Text,
                            ),
                          );
                          _formKey.currentState.reset();
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
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent)
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
                        }
                        return _imageMessageBubble(
                            _messages.senderID == widget.uid ? true : false,
                            _messages.content,
                            _messages.timestamp);
                      });
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
                ? _darkTheme ? Colors.grey[800] : Color(0xffff410f)
                : _darkTheme ? Colors.grey[600] : Color(0xfffff3f1),
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
                      color: isByMe ? Colors.white : _darkTheme? Colors.black:Color(0xff650000),
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
                ? _darkTheme ? Colors.grey[800] : Color(0xffff410f)
                : _darkTheme ? Colors.grey[800] : Color(0xfffff3f1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: isByMe ? Radius.circular(30) : Radius.circular(0),
                bottomRight:
                    isByMe ? Radius.circular(0) : Radius.circular(30))),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 7),
        child: Container(
            // constraints: BoxConstraints(
            //     maxHeight: MediaQuery.of(context).size.height * 0.08 +
            //         (_imageUrl.length / 20 * 5.0),
            //     maxWidth: MediaQuery.of(context).size.width * 2 / 3),
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width * 0.40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
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
              backgroundColor: _darkTheme ? Colors.white24 : Colors.white,
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
      backgroundColor: _darkTheme? Colors.white: Colors.white,
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
}

// class ChattingTile extends StatelessWidget {
//   final bool isByMe;
//   final String message;
//   ChattingTile({@required this.isByMe, @required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 24),
//       alignment: isByMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         decoration: BoxDecoration(
//             color: isByMe ? Color(0xffff410f) : Color(0xfffff3f1),
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),
//                 bottomLeft: isByMe ? Radius.circular(30) : Radius.circular(0),
//                 bottomRight:
//                     isByMe ? Radius.circular(0) : Radius.circular(30))),
//         padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         child: Container(
//           constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 2 / 3),
//           child: Text(
//             message,
//             style: TextStyle(
//                 color: isByMe ? Colors.white : Color(0xff650000),
//                 fontSize: 17,
//                 fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Container(
// //         width: MediaQuery.of(context).size.width,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: <Widget>[
// //             SizedBox(
// //               height: 90,
// //             ),
// //             ClipRRect(
// //               borderRadius: BorderRadius.circular(60),
// //               child: Image.network(
// //                 '${_receiverImage}',
// //                 height: 90,
// //                 width: 90,
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //             SizedBox(
// //               height: 14,
// //             ),
// //             Text(
// //               _receiverName,
// //               style: TextStyle(
// //                   color: Colors.black87,
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w700),
// //             ),
// //             SizedBox(
// //               height: 4,
// //             ),
// //             Text("5 minutes ago"),
// //             Container(
// //               padding: EdgeInsets.symmetric(horizontal: 24),
// //               child: ListView.builder(
// //                   itemCount: messages.length,
// //                   shrinkWrap: true,
// //                   itemBuilder: (context, index) {
// //                     return ChattingTile(
// //                       isByMe: messages[index].isByme,
// //                       message: messages[index].message,
// //                     );
// //                   }),
// //             )
// //           ],
// //         ),
// //       ),
// //       bottomSheet: Container(
// //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
// //         width: MediaQuery.of(context).size.width,
// //         child: Container(
// //           padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
// //           decoration: BoxDecoration(
// //               color: Color(0xffF4F5FA),
// //               borderRadius: BorderRadius.circular(30)),
// //           child: Row(
// //             children: <Widget>[
// //               Container(
// //                 padding: EdgeInsets.all(4),
// //                 decoration: BoxDecoration(
// //                   color: Color(0xffe7e7ef),
// //                   borderRadius: BorderRadius.circular(14),
// //                 ),
// //                 child: Image.asset(
// //                   "assets/images/more.png",
// //                   width: 30,
// //                   height: 30,
// //                 ),
// //               ),
// //               SizedBox(
// //                 width: 16,
// //               ),
// //               Expanded(
// //                 child: TextField(
// //                   decoration: InputDecoration.collapsed(
// //                       hintText: "Aa",
// //                       hintStyle:
// //                           TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
// //                 ),
// //               ),
// //               Container(
// //                 padding: EdgeInsets.all(4),
// //                 decoration: BoxDecoration(
// //                   color: Color(0xffe7e7ef),
// //                   borderRadius: BorderRadius.circular(14),
// //                 ),
// //                 child: Image.asset(
// //                   "assets/images/smile.png",
// //                   width: 30,
// //                   height: 30,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
