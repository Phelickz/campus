
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
   

  Post({
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
    this.createdAt
  });

  factory Post.fromMap(dynamic doc) => Post(
    documentID: doc['documentID'],
    createdAt: doc['createdAt'],
    profilePic: doc['profilePic'],
    username: doc['username'],
    comments: doc['comments'],
    likes: doc['likes'],
    date: doc["date"].toDate(),
    photoUrl: doc["photoUrl"],
    text: doc["text"],
    userId: doc["userId"],
    time: doc['time'].toDate()
  );
}

class Comments{
  String text;
  String userId;
  String photoUrl;
  String documentId;
  DateTime date;

  Comments({
    this.photoUrl,
    this.text,
    this.userId,
    this.documentId,
    this.date
  });

  factory Comments.fromDoc(dynamic doc) => Comments(
    documentId: doc.documentId,
    text: doc['text'],
    userId: doc['userId'],
    photoUrl: doc['photoUrl'],
    date: doc['date']
  );
}

class Likes{
  String userId;

  Likes({
    this.userId
  });

  factory Likes.fromDoc(dynamic doc) => Likes(
    userId: doc['userId']
  );
}

class Users{
  String email, username, photoUrl, bio, uid, followers, following, documentId;

  Users(this.bio, this.documentId, this.email, this.followers, this.following, this.photoUrl, this.uid, this.username);

  Users.fromMap(Map<String, dynamic> data){
    bio = data['bio'];
    documentId = data['documentId'];
    email = data['email'];
    followers = data['followers'].toString();
    following = data['following'].toString();
    photoUrl = data['photoUrl'];
    uid = data['uid'];
    username = data['username'];
  }

}
