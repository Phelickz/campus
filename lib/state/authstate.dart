import 'dart:io';

import 'package:campus/services/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:campus/services/auth.dart';
import 'package:campus/services/firestore.dart';
import 'package:campus/services/constants.dart';

const String kAuthError = 'error';
const String kAuthSuccess = 'success';
const String kAuthLoading = 'loading';
const String kAuthSignIn = 'signIn';

class AuthenticationState with ChangeNotifier{
  String _authStatus;
  String _username;
  String _uid;
  String _email;
  String _password;
  String _error;
  QuerySnapshot _userData;
  


  String get authStatus => _authStatus;
  String get username => _username;
  String get uid => _uid;
  String get email => _email;
  String get password => _password;
  String get error => _error;
  
  AuthenticationState(){
    clearState();

    onAuthenticationChange((user){
      if (user != null){
        _authStatus = kAuthSuccess;
        _username = user[kUsername];
        _uid = user[kUID];
        _email = user[email];
      }else {
        clearState();
      }
      notifyListeners();
    });
  }

  void checkAuthentication() async {
    _authStatus = kAuthLoading;
    if (await isUserSignedIn()){
      _authStatus = kAuthSuccess;

    }else {
      _authStatus = kAuthError;
    }
    notifyListeners();
  }

  void clearState(){
    _authStatus = null;
    _username = null;
    _uid = null;
    _email = null;
  }

  Future signup(email, password, username) async{
    return await signUp(email, password, username);
    
  }
  
  void login(email, password,) {
    try{
      signIn(email, password,);
      notifyListeners();
  } catch (e) {
    print(e);
  }
  }

  // void loginTest(email, password){
  //   signInWithEmail(email, password);
  // }
  

   logout() async {
    clearState();
    await signOut();
    notifyListeners();
  }

  currentUser(){
    notifyListeners();
    return getUser();
  }

  currentUserId(){
    notifyListeners();
    return getUserId();
  }

  Map<String, String> exposeCurrentUser(){
     notifyListeners();
   return exposeUser(
     kUsername: username, 
     kUID: uid);
    // notifyListeners();
  
  }

 checkUser(){
    isUserSignedIn();
  }

  void forgotPassword(email){
    sendPasswordResetEmail(email);
    notifyListeners();
  }

  getCurrentUser(){
    getUser();
    notifyListeners();
  }

  getPostsList(uid){
    getPostList(uid);
    notifyListeners();

  }
  
  getcomments(documentId){
    getCommentsList(documentId);
    notifyListeners();
  }

  addPosts(Post post, String uid, File imageFile, String profilePic, String username) async {
    await addPost(post, uid, imageFile, profilePic, username);
    notifyListeners();
  }

  updateProfilePicture(uid, File photo) async {
    addProfilePicture(uid, photo);
    notifyListeners();
  }

  updatePosts(Post post, String uid) async {
    await updatePost(post, uid);
    notifyListeners();
  }

  updatePosts2(Post post, String uid) async {
    updatePost2(post, uid);
    notifyListeners();
  }

  deletePosts(Post post, String uid) async {
    deletePost(post, uid);
    notifyListeners();
  }

  postComments(Comments comments, Post post) async {
    await addComment(comments, post);
    notifyListeners();
  }

  postLikes(String uid, Post post) async {
    await addLikes(uid, post);
    notifyListeners();
  }

  // getUserData(uid)  {
  // return getUsersData(uid);
  // } 
  
} 