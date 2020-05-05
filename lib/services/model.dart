import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String documentID;
  DateTime date;
  String photoUrl;
  String text;
  String userId;
  String profilePic;
  String username;
  int likes;
  int comments;
  DateTime time;
  Timestamp createdAt;
  bool liked;
  String videoUrl;
  String location;

  Post(
      {this.liked,
      this.profilePic,
      this.username,
      this.documentID,
      this.time,
      this.date,
      this.photoUrl,
      this.text,
      this.userId,
      this.likes,
      this.comments,
      this.videoUrl,
      this.location,
      this.createdAt});

  factory Post.fromMap(dynamic doc) => Post(
      documentID: doc['documentID'],
      createdAt: doc['createdAt'],
      profilePic: doc['profilePic'],
      username: doc['username'],
      comments: doc['comments'],
      likes: doc['likes'],
      date: doc["date"].toDate(),
      photoUrl: doc["photoUrl"],
      videoUrl: doc['videoUrl'],
      text: doc["text"],
      userId: doc["userId"],
      time: doc['time'].toDate(),
      location: doc['location'],
      liked: doc['liked']);
}

class User {
  String email,
      username,
      photoUrl,
      bio,
      uid,
      followers,
      following,
      documentId,
      phone,
      createdAt;
  List<String> followersList, followingList;

  User(
      {this.bio,
      this.createdAt,
      this.documentId,
      this.email,
      this.followers,
      this.following,
      this.photoUrl,
      this.uid,
      this.username,
      this.followersList,
      this.followingList,
      this.phone});

  factory User.fromMap(dynamic data) => User(
      phone: data['phone'],
      bio: data['bio'],
      documentId: data['documentId'],
      email: data['email'],
      followers: data['followers'].toString(),
      following: data['following'].toString(),
      photoUrl: data['photoUrl'],
      uid: data['uid'],
      username: data['username'],
      followersList: data['followersList'],
      followingList: data['followingList'],
      createdAt: data['createdAt']);
}

class Feeds {
  String userId;
  String documentId;
  String photoUrl;
  String profilePic;
  Timestamp createdAt;
  DateTime date;
  String text;
  String username;

  Feeds(
      {this.createdAt,
      this.date,
      this.username,
      this.documentId,
      this.photoUrl,
      this.profilePic,
      this.text,
      this.userId});

  factory Feeds.fromMap(dynamic doc) => Feeds(
        documentId: doc['documentID'],
        createdAt: doc['createdAt'],
        profilePic: doc['profilePic'],
        username: doc['username'],
        date: doc["date"].toDate(),
        photoUrl: doc["photoUrl"],
        text: doc["text"],
        userId: doc["userId"],
      );
}

class Likes {
  String userId;

  Likes({this.userId});

  factory Likes.fromDoc(dynamic doc) => Likes(userId: doc['userId']);
}

class Users {
  String email,
      username,
      photoUrl,
      bio,
      uid,
      followers,
      following,
      documentId,
      createdAt,
      phone,
      posts;
  List followersList, followingList;

  Users(
      this.bio,
      this.posts,
      this.documentId,
      this.email,
      this.createdAt,
      this.followers,
      this.following,
      this.photoUrl,
      this.uid,
      this.username,
      this.followersList,
      this.followingList,
      this.phone);

  Users.fromMap(Map<String, dynamic> data) {
    phone = data['phone'];
    bio = data['bio'];
    documentId = data['documentId'];
    email = data['email'];
    followers = data['followers'].toString();
    following = data['following'].toString();
    photoUrl = data['photoUrl'];
    uid = data['uid'];
    username = data['username'];
    createdAt = data['createdAt'].toString();
    posts = data['posts'].toString();
    followersList = data['followersList'];
    followingList = data['followingList'];
  }
}

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String lastMessage;
  final String name;
  final String image;
  final int unseenCount;
  final Timestamp timestamp;
  final MessageType type;

  ConversationSnippet(
      {this.conversationID,
      this.id,
      this.image,
      this.lastMessage,
      this.name,
      this.timestamp,
      this.unseenCount,
      this.type});

  factory ConversationSnippet.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;
    var _messageType = MessageType.Text;
    if (_data['type'] != null) {
      switch (_data['type']) {
        case 'text':
          break;
        case 'image':
          _messageType = MessageType.Image;
          break;
        case 'video':
          _messageType = MessageType.Video;
          break;
        default:
      }
    }
    return ConversationSnippet(
        id: _snapshot.documentID,
        conversationID: _data['conversationID'],
        lastMessage: _data['lastMessage'] != null ? _data['lastMessage'] : "",
        unseenCount: _data['unseenCount'],
        timestamp: _data['timestamp'],
        name: _data['username'],
        image: _data['image'],
        type: _messageType);
  }
}

class Conversation {
  final String id;
  final List members;
  final List<Message> messages;
  final String ownerId;

  Conversation({
    this.id,
    this.members,
    this.messages,
    this.ownerId,
  });

  factory Conversation.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;
    List _messages = _data['messages'];

    if (_messages != null) {
      _messages = _messages.map((_m) {
        var _messageType = _m['type'] == 'text'
            ? MessageType.Text
            : _m['type'] == 'image' ? MessageType.Image : MessageType.Video;
        return Message(
          senderID: _m['senderID'],
          content: _m['message'],
          timestamp: _m['timestamp'],
          type: _messageType,
        );
      }).toList();
    } else {
      _messages = null;
    }
    return Conversation(
        id: _snapshot.documentID,
        members: _data['members'],
        ownerId: _data['ownerID'],
        messages: _messages);
  }
}

enum MessageType { Text, Image, Video }

class Message {
  final String senderID;
  final String content;
  final Timestamp timestamp;
  final MessageType type;

  Message({this.content, this.senderID, this.timestamp, this.type});
}

class Comments {
  String message;
  String userId;
  String photoUrl;
  String documentId;
  DateTime date;
  Timestamp timestamp;

  Comments(
      {this.photoUrl,
      this.timestamp,
      this.message,
      this.userId,
      this.documentId,
      this.date});

  factory Comments.fromFirestore(DocumentSnapshot _snapshot) {
    return Comments(
        documentId: _snapshot.documentID,
        userId: _snapshot['userId'],
        photoUrl: _snapshot['photoUrl'],
        timestamp: _snapshot['timestamp'],
        message: _snapshot['message']);
  }
}

class Followers {
  String photoUrl;
  Timestamp timestamp;
  String uid;
  String username;
  String userId;

  Followers(
      {this.photoUrl, this.timestamp, this.uid, this.username, this.userId});

  factory Followers.fromMap(dynamic data) => Followers(
      photoUrl: data['photoUrl'],
      timestamp: data['timestamp'],
      uid: data['uid'],
      userId: data['userId'],
      username: data['username']);
}

class Topic {
  String userId;
  String topic;
  Timestamp timestamp;
  String documentID;
  int contributions;
  String category;

  Topic(
      {this.contributions,
      this.documentID,
      this.timestamp,
      this.topic,
      this.category,
      this.userId});

  factory Topic.fromMap(dynamic doc) => Topic(
      category: doc['category'],
      contributions: doc['contributions'],
      userId: doc['userId'],
      timestamp: doc['timestamp'],
      topic: doc['topic'],
      documentID: doc['documentID']);
}

class Contributions {
  String userId;
  String profilePic;
  String message;
  Timestamp timestamp;
  String username;
  String documentID;
  String photoUrl;
  int feedback;

  Contributions(
      {this.message,
      this.photoUrl,
      this.timestamp,
      this.userId,
      this.username,
      this.documentID,
      this.profilePic,
      this.feedback});

  factory Contributions.fromMap(dynamic doc) => Contributions(
      userId: doc['userId'],
      photoUrl: doc['photoUrl'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      profilePic: doc['profilePic'],
      username: doc['username'],
      feedback: doc['feedback'],
      documentID: doc['documentID']);
}
