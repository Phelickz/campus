
import 'dart:io';



import 'package:campus/services/auth.dart';
import 'package:campus/state/userState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'model.dart';



  Firestore _firestore = Firestore.instance;
  String _collectionPost = 'posts';
  String _userComments = 'comments';
  String _postLikes = 'likes';
    // String _userPost = 'posts';
  int likes = 0;
  int comments = 0;
  
  String url;

  Stream<List<Post>> getPostList(String uid) {
    return _firestore
      .collection(_collectionPost).where('userId'==uid)
      .snapshots()
      .map((QuerySnapshot snapshot){
        List<Post> _postDocs = snapshot.documents.map((doc) => 
          Post.fromMap(doc)).toList();
          _postDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
          return _postDocs;
      }
    );
  }

  Stream<List<Comments>> getCommentsList(String documentId){
    return _firestore
      .collection(_collectionPost)
      .document(documentId)
      .collection(_userComments)
      .snapshots()
      .map((QuerySnapshot snapshot){
        List<Comments> _commentDocs = snapshot.documents.map((doc)=>
          Comments.fromDoc(doc)
        ).toList();
        _commentDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
        return _commentDocs;
      });

  }

  Future<bool> addPost(Post post, String uid, File imagefile, String profilePic, String username) async {
   final DocumentReference _documentReference = 
    _firestore.collection(_collectionPost).document();

    var _timeKey = new DateTime.now();
  final StorageReference _postImageRef = FirebaseStorage.instance.ref().child('Post Images');
   final StorageUploadTask _uploadTask = _postImageRef.child(_timeKey.toString() + "jpg").putFile(imagefile);
   var imageUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

   url = imageUrl.toString();
   
    _documentReference.setData(
      {
          'userId': uid,
          'date' : post.date,
          'time' : post.time,
          'likes': post.likes,
          'comments': post.comments,
          'profilePic': profilePic,
          'username': username,
          'photoUrl': url,
          'text': post.text,
          'documentID': _documentReference.documentID,
          'createdAt': post.createdAt
        }
    );
    print('post added');
    return _documentReference.documentID != null;
  }

  Future<bool> addProfilePicture(String uid, File photo) async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // final DocumentReference _documentReference =
    //   _firestore.collection('userData').document(uid).collection('profile').document();

      var _timeKey = new DateTime.now();
      final StorageReference _postpicRef = FirebaseStorage.instance.ref().child('Profile pics');
      final StorageUploadTask _uploadTasks = _postpicRef.child(_timeKey.toString() + "jpg").putFile(photo);
      var _imageUrl = await (await _uploadTasks.onComplete).ref.getDownloadURL();
      String _url = _imageUrl.toString();

      // _documentReference.updateData(
      //   {
      //     'photoUrl' : _url
      //   }
      // );
      _firestore
        .collection('userData')
        .document(uid)
        .collection('profile')
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then((QuerySnapshot querySnapshot){
          querySnapshot.documents
          .forEach((DocumentSnapshot documentSnapshot){
            documentSnapshot.reference.updateData({
              'photoUrl' : _url
            }).catchError((e){
              print(e);
            });
          });
        }).catchError((e){
          print(e);
        });
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.photoUrl = _url;
      user.updateProfile(userUpdateInfo).catchError((e){
        print(e);
      });
      print('update success');
      return user != null;
  }

  Future<bool> addComment(Comments comments, Post post) async {
    DocumentReference _documentReference = 
      await _firestore
        .collection(_collectionPost)
        .document(post.documentID)
        .collection(_userComments)
        .add({
          'text': comments.text,
          'date': comments.date,
          'userId': comments.userId,
          'photoUrl': comments.photoUrl,
          'documentId': comments.documentId
        });
        return _documentReference.documentID != null;
  }

  Future<bool> addLikes(String uid, Post post) async {
    DocumentReference _documentReference = 
      await _firestore
        .collection(_collectionPost)
        .document(post.documentID)
        .collection(_postLikes)
        .add({
          
          'userId': uid,
          
        });
        return _documentReference.documentID != null;
  }

  Future<bool> addFollowers(String uid, String documentId, String url, String followerUId) async {
    DocumentReference _documentReference = 
     await _firestore
      .collection('userData')
      .document(uid)
      .collection("profile")
      .document(documentId)
      .collection('followers')
      .add({
        'userId': followerUId,
        'photoUrl': url
      });
      return _documentReference.documentID != null;
  }

  Future updatePost(Post post, String uid) async {
    DocumentReference _docRef = 
     _firestore
      .collection(_collectionPost)
      .document(post.documentID);

      var postData = {
        'likes': post.likes,
        'comments': post.comments,
        'text': post.text
      };

      _firestore.runTransaction((transaction) async{
        await transaction
          .update(_docRef, postData)
          .catchError((e) => print(e));
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
      }).catchError((e) {print(e);
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
  QuerySnapshot snapshot = await _firestore.collection('userData').document(uid).collection('profile').getDocuments();

  List<Users> _usersList = [];

  snapshot.documents.forEach((document) async{
    Users user = Users.fromMap(document.data);
    _usersList.add(user);
  });

  userNotifier.userProfileData = _usersList;
}

getUsersPosts(UserNotifier userNotifier) async {
  QuerySnapshot snapshot = await _firestore.collection(_collectionPost).orderBy('createdAt').getDocuments();
  List<Post> _usersPosts = [];

  snapshot.documents.forEach((document) async {
    Post post = Post.fromMap(document.data);
    _usersPosts.add(post);
    
  });
  userNotifier.usersPosts = _usersPosts;
} 