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

class AuthenticationState with ChangeNotifier {
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

  AuthenticationState() {
    clearState();

    onAuthenticationChange((user) {
      if (user != null) {
        _authStatus = kAuthSuccess;
        _username = user[kUsername];
        _uid = user[kUID];
        _email = user[email];
      } else {
        clearState();
      }
      notifyListeners();
    });
  }

  void checkAuthentication() async {
    _authStatus = kAuthLoading;
    if (await isUserSignedIn()) {
      _authStatus = kAuthSuccess;
    } else {
      _authStatus = kAuthError;
    }
    notifyListeners();
  }

  void clearState() {
    _authStatus = null;
    _username = null;
    _uid = null;
    _email = null;
  }

  Future signup(email, password, username, phone) async {
    return await signUp(email, password, username, phone);
  }

  login(
    email,
    password,
  ) {
    try {
      signIn(
        email,
        password,
      );
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

  currentUser() {
    // notifyListeners();
    return getUser();
  }

  currentUserId() {
    // notifyListeners();
    return getUserId();
  }

  Map<String, String> exposeCurrentUser() {
    notifyListeners();
    return exposeUser(kUsername: username, kUID: uid);
    // notifyListeners();
  }

  checkUser() {
    isUserSignedIn();
  }

  void forgotPassword(email) {
    sendPasswordResetEmail(email);
    notifyListeners();
  }

  getCurrentUser() {
    getUser();
  }

  getcomments(documentId) {
    return getCommentsList(documentId);
  }

  addPosts(Post post, String uid, File imageFile, String profilePic,
      String username, File videoUrl) async {
    await addPost(post, uid, imageFile, profilePic, username, videoUrl);
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

  postComments(String _postId, String _userId, String _photoUrl,
      Comments _comments) async {
    await addComment(_postId, _userId, _photoUrl, _comments);
    notifyListeners();
  }

  postLikes(String uid, String postId, String photoUrl) async {
    await addLikes(uid, postId, photoUrl);
    notifyListeners();
  }

  reduceLikes(String postId) {
    notifyListeners();
    return removeLikesCount(postId);
  }

  updateLikess(String postId) {
    notifyListeners();
    return updateLikes(postId);
  }

  removeLikesId(String uid, String postId) {
    notifyListeners();
    return removeLikes(uid, postId);
  }
  // getUserData(uid)  {
  // return getUsersData(uid);
  // }

  userConversations(String uid) {
    // notifyListeners();
    return getUserConversation(uid);
  }

  getPostsWithIDS(String uid) {
    return getPostList(uid);
  }

  getPosts() {
    return getAllPostList();
  }

  getConversationss(String conversationID) {
    return getConversation(conversationID);
  }

  sendAMessage(String _conversationID, Message _message) {
    sendMessage(_conversationID, _message);
  }

  sendAPhoto(uid, File _file, String conversationID, Message _message) {
    return addImage(uid, _file, conversationID, _message);
  }

  sendAVideo(uid, File _file, String conversationID, Message _message) {
    return addVideo(uid, _file, conversationID, _message);
  }

  createNewMessage(String _currentID, String _recepientID,
      Future<void> _onSuccess(String _conversationID)) {
    createOrGetConversations(_currentID, _recepientID, _onSuccess);
  }

  getAllUsersData() {
    return getAllUsers();
  }

  getComments(String _postId) {
    return getCommentsList(_postId);
  }

  follow(String uid, String url, String followerUId, String username,
      String followedUsername) {
    return addFollowers(uid, url, followerUId, username, followedUsername);
  }

  unFollowUser(String uid, String url, String followerUId, String username) {
    return unFollow(uid, url, followerUId, username);
  }

  getFollowers(String uid) {
    return getAllFollowers(uid);
  }

  getFollowing(String uid) {
    return getAllFollowing(uid);
  }

  addCommunityTopic(String userId, Topic topic) {
    return addTopic(userId, topic);
  }

  addCommunityTopicComment(String topicId, Contributions contributions,
      String userId, String profilePic, String username, File imagefile) {
    return addTopicComment(
        topicId, contributions, userId, profilePic, username, imagefile);
  }

  addCommunityCommentFeedback(
      String topicId,
      Contributions contributions,
      String userId,
      String profilePic,
      String username,
      String contributionId,
      File imagefile) {
    return addCommentFeedBack(topicId, contributions, userId, profilePic,
        username, contributionId, imagefile);
  }

  getTopics(){
    return getAllTopics();
  }

  getContributions(String topicId){
   return getTopicContributions(topicId);
  }
}
