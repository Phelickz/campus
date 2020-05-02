import 'package:campus/data/data.dart';
import 'package:campus/models/chat_model.dart';
import 'package:campus/models/story_model.dart';
import 'package:campus/services/model.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat.dart';

class Home extends StatefulWidget {
  final _uid;
  Home(this._uid);
  @override
  _HomeState createState() => _HomeState(this._uid);
}

class _HomeState extends State<Home> {
  var _darkTheme;
  final _uid;
  _HomeState(this._uid);
  List<StoryModel> stories = new List();
  List<ChatModel> chats = new List();

  @override
  void initState() {
    super.initState();
    stories = getStories();
    // chats = getChats();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Consumer<AuthenticationState>(
      builder: (context, _authState, child) {
        return Scaffold(
          backgroundColor: Color(0xff171719),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 70,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Messages",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(0xff444446),
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),

                  /// now stories
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    height: 120,
                    child: ListView.builder(
                        itemCount: stories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return StoryTile(
                            imgUrl: stories[index].imgUrl,
                            username: stories[index].username,
                          );
                        }),
                  ),

                  /// CHats
                  ///
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: _darkTheme ? Colors.black87 : Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Recent",
                                    style: TextStyle(
                                        color: _darkTheme
                                            ? Colors.white
                                            : Colors.black45,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.more_vert,
                                    color: Colors.black45,
                                  )
                                ],
                              ),
                            ),
                            StreamBuilder<List<ConversationSnippet>>(
                              stream: _authState.userConversations(_uid),
                              builder: (context, _snapshot) {
                                var _data = _snapshot.data;
                                return _snapshot.hasData
                                    ? ListView.builder(
                                        itemCount: _data.length,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                    _uid,
                                                    _data[index].conversationID,
                                                    _data[index].id,
                                                    _data[index].image,
                                                    _data[index].name,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ChatTile(
                                              imgUrl: _data[index].image,
                                              name: _data[index].name,
                                              lastMessage: _data[index].type ==
                                                      MessageType.Text
                                                  ? _data[index].lastMessage
                                                  : _data[index].type ==
                                                          MessageType.Image
                                                      ? 'Attachment: Photo'
                                                      : 'Attachment: Video',
                                              haveunreadmessages: false,
                                              unreadmessages: 1,
                                              lastSeenTime: timeago.format(
                                                  _data[index]
                                                      .timestamp
                                                      .toDate()),
                                              conversationID:
                                                  _data[index].conversationID,
                                              id: _data[index].id,
                                              uid: _uid,
                                            ),
                                          );
                                        })
                                    : CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // getUserId() async {
  //   final uid = await Provider.of<AuthenticationState>(context, listen: false)
  //       .currentUserId();
  //   setState(() {
  //     _uid = uid;
  //   });
  //   return uid;
  // }
}

class StoryTile extends StatelessWidget {
  final String imgUrl;
  final String username;
  StoryTile({@required this.imgUrl, @required this.username});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.network(
              imgUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            username,
            style: TextStyle(
                color: Color(0xff78778a),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  var _darkTheme;
  final String uid;
  final String id;
  final String conversationID;
  final String imgUrl;
  final String name;
  final String lastMessage;
  final bool haveunreadmessages;
  final int unreadmessages;
  final String lastSeenTime;
  ChatTile(
      {@required this.unreadmessages,
      @required this.uid,
      @required this.id,
      @required this.conversationID,
      @required this.haveunreadmessages,
      @required this.lastSeenTime,
      @required this.lastMessage,
      @required this.imgUrl,
      @required this.name});
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      uid,
                      conversationID,
                      id,
                      imgUrl,
                      name,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                imgUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                color: _darkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        color: _darkTheme ? Colors.white : Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    lastMessage.length >= 30
                        ? lastMessage.substring(0, 25) + '...'
                        : lastMessage,
                    style: TextStyle(
                        color: _darkTheme ? Colors.white : Colors.black54,
                        fontSize: 15,
                        fontFamily: "Neue Haas Grotesk"),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 14,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(lastSeenTime),
                  SizedBox(
                    height: 16,
                  ),
                  haveunreadmessages
                      ? Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color(0xffff410f),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "$unreadmessages",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ))
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
