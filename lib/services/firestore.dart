import 'dart:io';

import 'package:campus/state/userState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'model.dart';

Firestore _firestore = Firestore.instance;
String _collectionPost = 'posts';
String _userComments = 'comments';
String _postLikes = 'likes';
String _collectionFeed = 'feeds';
String _conversationCollection = 'Conversations';
// String _userPost = 'posts';
int likes = 0;
int comments = 0;
QuerySnapshot querySnapshot;

StorageReference _baseRef;
String _messages = 'messages';
String _images = 'images';

Future<bool> addPost(
  Post post,
  String uid,
  File imagefile,
  String profilePic,
  String username,
  File videofile,
) async {
  final DocumentReference _documentReference =
      _firestore.collection(_collectionPost).document();

  var _timeKey = new DateTime.now();

  if (imagefile != null) {
    final StorageReference _postImageRef =
        FirebaseStorage.instance.ref().child('Post Images');
    final StorageUploadTask _uploadTask =
        _postImageRef.child(_timeKey.toString() + "jpg").putFile(imagefile);
    var imageUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

    String url = imageUrl.toString();

    _documentReference.setData({
      'userId': uid,
      'date': post.date,
      'time': post.time,
      'likes': post.likes,
      'comments': post.comments,
      'profilePic': profilePic,
      'username': username,
      'photoUrl': url,
      'videoUrl': videofile,
      'text': post.text,
      'documentID': _documentReference.documentID,
      'createdAt': post.createdAt,
      'liked': post.liked,
      'location': post.location
    });
  } else {
    var _timeKey = new DateTime.now();
    final StorageReference _postImageRef =
        FirebaseStorage.instance.ref().child('Post Images');
    final StorageUploadTask _uploadTask = _postImageRef
        .child(_timeKey.toString() + "mp4")
        .putFile(videofile, StorageMetadata(contentType: 'video/mp4'));
    var videoUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

    String url = videoUrl.toString();

    _documentReference.setData({
      'userId': uid,
      'date': post.date,
      'time': post.time,
      'likes': post.likes,
      'comments': post.comments,
      'profilePic': profilePic,
      'username': username,
      'photoUrl': imagefile,
      'videoUrl': url,
      'text': post.text,
      'documentID': _documentReference.documentID,
      'createdAt': post.createdAt,
      'liked': post.liked,
      'location': post.location
    });
  }

  await _firestore
      .collection('userData')
      .where('uid', isEqualTo: uid)
      .getDocuments()
      .then((snapshot) {
    for (DocumentSnapshot doc in snapshot.documents) {
      doc.reference.updateData({'posts': FieldValue.increment(1)});
    }
  });
  print('post added');
  // SnackBarService.instance.showSnackBarSuccess('Post Upload Successful');
  return _documentReference.documentID != null;
}

Future<bool> addPostVideo(Post post, String uid, File videofile,
    String profilePic, String username) async {
  final DocumentReference _documentReference =
      _firestore.collection(_collectionPost).document();

  var _timeKey = new DateTime.now();
  final StorageReference _postImageRef =
      FirebaseStorage.instance.ref().child('Post Images');
  final StorageUploadTask _uploadTask = _postImageRef
      .child(_timeKey.toString() + "mp4")
      .putFile(videofile, StorageMetadata(contentType: 'video/mp4'));
  var imageUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

  String url = imageUrl.toString();

  _documentReference.setData({
    'userId': uid,
    'date': post.date,
    'time': post.time,
    'likes': post.likes,
    'comments': post.comments,
    'profilePic': profilePic,
    'username': username,
    'photoUrl': url,
    'text': post.text,
    'documentID': _documentReference.documentID,
    'createdAt': post.createdAt
  });
  print('post added');
  return _documentReference.documentID != null;
}

Future<bool> addFeedImage(Feeds feed, String uid, File imagefile,
    String profilePic, String username) async {
  final DocumentReference _documentReference =
      _firestore.collection(_collectionFeed).document();

  var _timeKey = new DateTime.now();
  final StorageReference _postImageRef =
      FirebaseStorage.instance.ref().child('Feed Images');
  final StorageUploadTask _uploadTask =
      _postImageRef.child(_timeKey.toString() + "jpg").putFile(imagefile);
  var imageUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

  String url = imageUrl.toString();

  _documentReference.setData({
    'userId': uid,
    'date': feed.date,
    'profilePic': profilePic,
    'username': username,
    'photoUrl': url,
    'text': feed.text,
    'documentId': _documentReference.documentID,
    'createdAt': feed.createdAt
  });
  print('post added');
  return _documentReference.documentID != null;
}

Future<bool> addFeedVideo(Feeds feed, String uid, File videoFile,
    String profilePic, String username) async {
  final DocumentReference _documentReference =
      _firestore.collection(_collectionFeed).document();

  var _timeKey = new DateTime.now();
  final StorageReference _postImageRef =
      FirebaseStorage.instance.ref().child('Feed Images/Videos');
  final StorageUploadTask _uploadTask = _postImageRef
      .child(_timeKey.toString() + "mp4")
      .putFile(videoFile, StorageMetadata(contentType: 'video/mp4'));
  var imageUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

  String url = imageUrl.toString();

  _documentReference.setData({
    'userId': uid,
    'date': feed.date,
    'profilePic': profilePic,
    'username': username,
    'photoUrl': url,
    'text': feed.text,
    'documentId': _documentReference.documentID,
    'createdAt': feed.createdAt
  });
  print('post added');
  return _documentReference.documentID != null;
}

Future<bool> addProfilePicture(String uid, File photo) async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  // final DocumentReference _documentReference =
  //   _firestore.collection('userData').document(uid).collection('profile').document();

  var _timeKey = new DateTime.now();
  final StorageReference _postpicRef =
      FirebaseStorage.instance.ref().child('Profile pics');
  final StorageUploadTask _uploadTasks =
      _postpicRef.child(_timeKey.toString() + "jpg").putFile(photo);
  var _imageUrl = await (await _uploadTasks.onComplete).ref.getDownloadURL();
  String _url = _imageUrl.toString();

  // _documentReference.updateData(
  //   {
  //     'photoUrl' : _url
  //   }
  // );
  _firestore
      .collection('userData')
      .where('uid', isEqualTo: uid)
      .getDocuments()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
      documentSnapshot.reference.updateData({'photoUrl': _url}).catchError((e) {
        print(e);
      });
    });
  }).catchError((e) {
    print(e);
  });
  var userUpdateInfo = UserUpdateInfo();
  userUpdateInfo.photoUrl = _url;
  user.updateProfile(userUpdateInfo).catchError((e) {
    print(e);
  });

  await _firestore
      .collection('posts')
      .where('userId', isEqualTo: uid)
      .getDocuments()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
      documentSnapshot.reference
          .updateData({'profilePic': _url}).catchError((e) {
        print(e);
      });
    });
  }).catchError((e) {
    print(e);
  });

  print('update success');
  return user != null;
}

Future<void> updateProfile(
    String uid, String username, String email, String bio, String phone) async {
  _firestore
      .collection('userData')
      .where('uid', isEqualTo: uid)
      .getDocuments()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
      documentSnapshot.reference.updateData({
        'username': username,
        'bio': bio,
        'email': email,
        'phone': phone
      }).catchError((e) {
        print(e);
      });
    });
  }).catchError((e) {
    print(e);
  });
}

Future<void> addLikes(
    String uid, String postId, String photoUrl, String username) async {
  await _firestore
      .collection(_collectionPost)
      .document(postId)
      .collection(_postLikes)
      .document(uid)
      .setData({'userId': uid, 'photoUrl': photoUrl});

  await _firestore
      .collection('userData')
      .document(uid)
      .collection('notifications')
      .add({
    'timestamp': Timestamp.now(),
    'photoUrl': photoUrl,
    'message': username + ' liked your post',
  });
}

void removeLikes(String uid, String postId) async {
  _firestore
      .collection(_collectionPost)
      .document(postId)
      .collection(_postLikes)
      .where('userId', isEqualTo: uid)
      .getDocuments()
      .then((snapshot) {
    for (DocumentSnapshot doc in snapshot.documents) {
      doc.reference.delete();
    }
  }).catchError((e) {
    print(e);
  });
}

void updateLikes(String postId) async {
  _firestore
      .collection(_collectionPost)
      .document(postId)
      .updateData({'likes': FieldValue.increment(1)}).catchError((e) {
    print(e);
  });
}

void removeLikesCount(String postId) async {
  _firestore
      .collection(_collectionPost)
      .document(postId)
      .updateData({'likes': FieldValue.increment(-1)}).catchError((e) {
    print(e);
  });
}

Future<void> addFollowers(String uid, String url, String followerUId,
    String username, String followedUsername, String followedUrl) async {
  await _firestore
      .collection('userData')
      .document(uid)
      .collection('followers')
      .document(followerUId)
      .setData({
    'userId': followerUId,
    'uid': uid,
    'photoUrl': url,
    'username': username,
    'timestamp': Timestamp.now()
  });

  await _firestore
      .collection('userData')
      .document(uid)
      .collection('notifications')
      .add({
    'timestamp': Timestamp.now(),
    'photoUrl': url,
    'message': username + ' just followed you',
  });

  await _firestore
      .collection('userData')
      .document(followerUId)
      .collection('following')
      .document(uid)
      .setData({
    'uid': uid,
    'photoUrl': followedUrl,
    'username': followedUsername,
    'timestamp': Timestamp.now()
  });

  await _firestore.collection('userData').document(followerUId).updateData({
    'followingList': FieldValue.arrayUnion([uid])
  });

  await _firestore.collection('userData').document(uid).updateData({
    'followersList': FieldValue.arrayUnion([followerUId])
  });
}

Future<void> unFollow(
    String uid, String url, String followerUId, String username) async {
  await _firestore
      .collection('userData')
      .document(uid)
      .collection('followers')
      .document(followerUId)
      .delete();

  await _firestore
      .collection('userData')
      .document(followerUId)
      .collection('following')
      .document(uid)
      .delete();

  await _firestore.collection('userData').document(followerUId).updateData({
    'followingList': FieldValue.arrayRemove([uid])
  });

  await _firestore.collection('userData').document(uid).updateData({
    'followersList': FieldValue.arrayRemove([followerUId])
  });
}

Future updatePost(Post post, String uid) async {
  DocumentReference _docRef =
      _firestore.collection(_collectionPost).document(post.documentID);

  var postData = {
    'likes': post.likes,
    'comments': post.comments,
    'text': post.text
  };

  _firestore.runTransaction((transaction) async {
    await transaction.update(_docRef, postData).catchError((e) => print(e));
  });
}

void updatePost2(Post post, String uid) async {
  await _firestore
      .collection(_collectionPost)
      .document(post.documentID)
      .updateData({
    'likes': post.likes,
    'comments': post.comments,
    'text': post.text
  }).catchError((e) {
    print(e);
  });
}

void deletePost(Post post, String uid) async {
  await _firestore
      .collection(_collectionPost)
      .document(post.documentID)
      .delete()
      .catchError((e) {
    print(e);
  });
}

getUsersData(UserNotifier userNotifier, String uid) async {
  QuerySnapshot snapshot = await _firestore
      .collection('userData')
      .where('uid', isEqualTo: uid)
      .getDocuments();

  List<Users> _usersList = [];

  snapshot.documents.forEach((document) async {
    Users user = Users.fromMap(document.data);
    _usersList.add(user);
  });

  userNotifier.userProfileData = _usersList;
}

getUsersPosts(UserNotifier userNotifier) async {
  QuerySnapshot snapshot = await _firestore
      .collection(_collectionPost)
      .orderBy('createdAt')
      .getDocuments();
  List<Post> _usersPosts = [];

  snapshot.documents.forEach((document) async {
    Post post = Post.fromMap(document.data);
    _usersPosts.add(post);
  });
  userNotifier.usersPosts = _usersPosts;
}

getUsersPostsWithId(UserNotifier userNotifier, String uid) async {
  QuerySnapshot snapshot = await _firestore
      .collection(_collectionPost)
      .where('userId', isEqualTo: uid)
      .getDocuments();
  List<Post> _usersPostsWithId = [];

  snapshot.documents.forEach((document) async {
    Post post = Post.fromMap(document.data);
    _usersPostsWithId.add(post);
    print('success');
  });
  userNotifier.usersPosts = _usersPostsWithId;
}

getUsersFeeds(UserNotifier userNotifier) async {
  QuerySnapshot snapshot = await _firestore
      .collection(_collectionFeed)
      .orderBy('createdAt')
      .getDocuments();
  List<Feeds> _usersFeeds = [];

  snapshot.documents.forEach((document) async {
    Feeds feed = Feeds.fromMap(document.data);
    _usersFeeds.add(feed);
  });

  userNotifier.userFeeds = _usersFeeds;
}

Stream<List<ConversationSnippet>> getUserConversation(String _userID) {
  var _ref = _firestore
      .collection('userData')
      .document(_userID)
      .collection(_conversationCollection);
  return _ref.snapshots().map((_snapshot) {
    return _snapshot.documents.map((_doc) {
      return ConversationSnippet.fromFirestore(_doc);
    }).toList();
  });
}

Stream<List<Post>> getPostWithId(String uid) {
  var _ref =
      _firestore.collection(_collectionPost).where('userId', isEqualTo: uid);
  return _ref.snapshots().map((_snapshot) {
    return _snapshot.documents.map((_doc) {
      return Post.fromMap(_doc);
    }).toList();
  });
}

Stream<List<Post>> getPostList(String uid) {
  return _firestore
      .collection(_collectionPost)
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map((QuerySnapshot snapshot) {
    List<Post> _postDocs =
        snapshot.documents.map((doc) => Post.fromMap(doc)).toList();
    _postDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
    return _postDocs;
  });
}

Stream<List<User>> getUsersList() {
  return _firestore
      .collection('userData')
      .snapshots()
      .map((QuerySnapshot snapshot) {
    List<User> _postDocs =
        snapshot.documents.map((doc) => User.fromMap(doc)).toList();
    _postDocs
        .sort((comp1, comp2) => comp2.createdAt.compareTo(comp1.createdAt));
    return _postDocs;
  });
}

Stream<List<User>> getAllUsers() {
  var _ref = _firestore.collection('userData').orderBy('createdAt');
  return _ref.snapshots().map((_snapshot) {
    return _snapshot.documents.map((_doc) {
      return User.fromMap(_doc);
    }).toList();
  });
}

Stream<List<Followers>> getAllFollowers(String uid) {
  var _ref = _firestore
      .collection('userData')
      .document(uid)
      .collection('followers')
      .orderBy('timestamp');
  return _ref.snapshots().map((_snapshot) {
    return _snapshot.documents.map((_doc) {
      return Followers.fromMap(_doc);
    }).toList();
  });
}

Stream<List<Followers>> getAllFollowing(String uid) {
  var _ref = _firestore
      .collection('userData')
      .document(uid)
      .collection('following')
      .orderBy('timestamp');
  return _ref.snapshots().map((_snapshot) {
    return _snapshot.documents.map((_doc) {
      return Followers.fromMap(_doc);
    }).toList();
  });
}

Stream<List<Post>> getAllPostList() {
  return _firestore
      .collection(_collectionPost)
      .snapshots()
      .map((QuerySnapshot snapshot) {
    List<Post> _postDocs =
        snapshot.documents.map((doc) => Post.fromMap(doc)).toList();
    _postDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
    return _postDocs;
  });
}

Stream<Conversation> getConversation(String _conversationID) {
  var _ref =
      _firestore.collection(_conversationCollection).document(_conversationID);
  return _ref.snapshots().map((_snapshot) {
    return Conversation.fromFirestore(_snapshot);
  });
}

Stream<List<Comments>> getCommentsList(String _postId) {
  return _firestore
      .collection(_collectionPost)
      .document(_postId)
      .collection(_userComments)
      .snapshots()
      .map((QuerySnapshot snapshot) {
    List<Comments> _commentDocs =
        snapshot.documents.map((doc) => Comments.fromFirestore(doc)).toList();
    _commentDocs.sort((comp1, comp2) =>
        comp2.timestamp.toDate().compareTo(comp1.timestamp.toDate()));
    return _commentDocs;
  });
}

Future<void> sendMessage(String _conversationID, Message _message) {
  var _ref =
      _firestore.collection(_conversationCollection).document(_conversationID);
  var _messageType = '';
  switch (_message.type) {
    case MessageType.Text:
      _messageType = 'text';
      break;
    case MessageType.Image:
      _messageType = 'image';
      break;
    case MessageType.Video:
      _messageType = 'video';
      break;
    default:
  }
  return _ref.updateData({
    "messages": FieldValue.arrayUnion([
      {
        'message': _message.content,
        'senderID': _message.senderID,
        'timestamp': _message.timestamp,
        'type': _messageType
      }
    ])
  });
}

Future<void> addComment(String _postId, String _userId, String _photoUrl,
    Comments _comments) async {
  var _ref = _firestore
      .collection(_collectionPost)
      .document(_postId)
      .collection(_userComments)
      .document();

  await _firestore
      .collection(_collectionPost)
      .document(_postId)
      .updateData({'comments': FieldValue.increment(1)}).catchError((e) {
    print(e);
  });

  return _ref.setData({
    'userId': _userId,
    'photoUrl': _photoUrl,
    'message': _comments.message,
    'timestamp': _comments.timestamp
  });
}

Future<void> addImage(String _uid, File _imagefile, String _conversationID,
    Message _message) async {
  final DocumentReference _documentReference =
      _firestore.collection(_conversationCollection).document(_conversationID);

  var _timeKey = new DateTime.now();
  var _filename = basename(_imagefile.path);
  _filename += '${_timeKey.toString()}';
  final StorageReference _postImageRef = FirebaseStorage.instance
      .ref()
      .child(_messages)
      .child(_uid)
      .child(_images);
  final StorageUploadTask _uploadTask =
      _postImageRef.child(_filename).putFile(_imagefile);
  var imageUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

  String url = imageUrl.toString();

  var _messageType = '';
  switch (_message.type) {
    case MessageType.Text:
      _messageType = 'text';
      break;
    case MessageType.Image:
      _messageType = 'image';
      break;
    case MessageType.Video:
      _messageType = 'video';
      break;
    default:
  }
  await _documentReference.updateData({
    "messages": FieldValue.arrayUnion([
      {
        'message': url,
        'senderID': _message.senderID,
        'timestamp': _message.timestamp,
        'type': _messageType
      }
    ])
  });
  print('post added');
  return _documentReference.documentID != null;
}

Future<void> addVideo(String _uid, File _videofile, String _conversationID,
    Message _message) async {
  final DocumentReference _documentReference =
      _firestore.collection(_conversationCollection).document(_conversationID);

  var _timeKey = new DateTime.now();
  var _filename = basename(_videofile.path);
  _filename += '${_timeKey.toString()}';
  final StorageReference _postImageRef = FirebaseStorage.instance
      .ref()
      .child(_messages)
      .child(_uid)
      .child(_images);
  final StorageUploadTask _uploadTask = _postImageRef
      .child(_filename + "mp4")
      .putFile(_videofile, StorageMetadata(contentType: 'video/mp4'));
  var videoUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

  String url = videoUrl.toString();

  var _messageType = '';
  switch (_message.type) {
    case MessageType.Text:
      _messageType = 'text';
      break;
    case MessageType.Image:
      _messageType = 'image';
      break;
    case MessageType.Video:
      _messageType = 'video';
      break;
    default:
  }
  await _documentReference.updateData({
    "messages": FieldValue.arrayUnion([
      {
        'message': url,
        'senderID': _message.senderID,
        'timestamp': _message.timestamp,
        'type': _messageType
      }
    ])
  });
  print('post added');
  return _documentReference.documentID != null;
}

Future<void> createOrGetConversations(String _currentID, String _recepientID,
    Future<void> _onSuccess(String _conversationID)) async {
  var _ref = _firestore.collection(_conversationCollection);
  var _userConversationCollection = _firestore
      .collection('userData')
      .document(_currentID)
      .collection(_conversationCollection);
  try {
    var conversation =
        await _userConversationCollection.document(_recepientID).get();
    if (conversation.data != null) {
      return _onSuccess(conversation.data['conversationID']);
    } else {
      var _conversationRef = _ref.document();
      await _conversationRef.setData({
        'members': [_currentID, _recepientID],
        'ownerID': _currentID,
        'messsages': []
      });
      return _onSuccess(_conversationRef.documentID);
    }
  } catch (e) {
    print(e);
  }
}

Future<void> addTopic(String userId, Topic topic) async {
  final DocumentReference _documentReference =
      _firestore.collection('community').document();

  await _documentReference.setData({
    'userId': userId,
    'topic': topic.topic,
    'timestamp': topic.timestamp,
    'documentID': _documentReference.documentID,
    'contributions': 0,
    'category': topic.category
  });
}

Future<void> addTopicComment(
    String _topicId,
    Contributions _contributions,
    String _userId,
    String _profilePic,
    String _username,
    File imagefile) async {
  var _ref = _firestore
      .collection('community')
      .document(_topicId)
      .collection('contributions')
      .document();

  if (_contributions.message == null) {
    var _timeKey = DateTime.now();
    final StorageReference _postImageRef =
        FirebaseStorage.instance.ref().child('Community images');
    final StorageUploadTask _uploadTask =
        _postImageRef.child(_timeKey.toString() + "jpg").putFile(imagefile);
    var imageUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

    String url = imageUrl.toString();

    await _firestore
        .collection('community')
        .document(_topicId)
        .updateData({'contributions': FieldValue.increment(1)}).catchError((e) {
      print(e);
    });

    return _ref.setData({
      'userId': _userId,
      'photoUrl': url,
      'message': _contributions.message,
      'timestamp': _contributions.timestamp,
      'profilePic': _profilePic,
      'username': _username,
      'documentID': _ref.documentID,
      'feedback': 0
    });
  } else {
    await _firestore
        .collection('community')
        .document(_topicId)
        .updateData({'contributions': FieldValue.increment(1)}).catchError((e) {
      print(e);
    });

    return _ref.setData({
      'userId': _userId,
      'photoUrl': imagefile,
      'message': _contributions.message,
      'timestamp': _contributions.timestamp,
      'profilePic': _profilePic,
      'username': _username,
      'documentID': _ref.documentID,
      'feedback': 0
    });
  }
}

Future<void> addCommentFeedBack(
    String _topicId,
    Contributions _contributions,
    String _userId,
    String _profilePic,
    String _username,
    String _contributionId,
    File imagefile) async {
  var _ref = _firestore
      .collection('community')
      .document(_topicId)
      .collection('contributions')
      .document(_contributionId)
      .collection('feedback')
      .document();

  if (_contributions.message == null) {
    var _timeKey = DateTime.now();
    final StorageReference _postImageRef =
        FirebaseStorage.instance.ref().child('Community images');
    final StorageUploadTask _uploadTask =
        _postImageRef.child(_timeKey.toString() + "jpg").putFile(imagefile);
    var imageUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

    String url = imageUrl.toString();

    await _firestore
        .collection('community')
        .document(_topicId)
        .collection('contributions')
        .document(_contributionId)
        .updateData({'feedback': FieldValue.increment(1)}).catchError((e) {
      print(e);
    });

    return _ref.setData(
      {
        'userId': _userId,
        'photoUrl': url,
        'message': _contributions.message,
        'timestamp': _contributions.timestamp,
        'profilePic': _profilePic,
        'username': _username,
        'documentID': _ref.documentID
      },
    );
  } else {
    await _firestore
        .collection('community')
        .document(_topicId)
        .collection('contributions')
        .document(_contributionId)
        .updateData({'feedback': FieldValue.increment(1)}).catchError((e) {
      print(e);
    });

    return _ref.setData({
      'userId': _userId,
      'photoUrl': imagefile,
      'message': _contributions.message,
      'timestamp': _contributions.timestamp,
      'profilePic': _profilePic,
      'username': _username,
      'documentID': _ref.documentID
    });
  }
}

Stream<List<Topic>> getAllTopics() {
  return _firestore
      .collection('community')
      .snapshots()
      .map((QuerySnapshot snapshot) {
    List<Topic> _topicDocs =
        snapshot.documents.map((doc) => Topic.fromMap(doc)).toList();
    _topicDocs.sort((comp1, comp2) =>
        comp2.timestamp.toDate().compareTo(comp1.timestamp.toDate()));
    return _topicDocs;
  });
}

Stream<List<Contributions>> getTopicContributions(String _topicId) {
  return _firestore
      .collection('community')
      .document(_topicId)
      .collection('contributions')
      .snapshots()
      .map((QuerySnapshot snapshot) {
    List<Contributions> _contributionDocs =
        snapshot.documents.map((doc) => Contributions.fromMap(doc)).toList();
    // _contributionDocs.sort((comp1, comp2) =>
    //     comp2.timestamp.toDate().compareTo(comp1.timestamp.toDate()));
    return _contributionDocs;
  });
}
