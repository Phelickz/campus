
import 'dart:collection';

import 'package:campus/services/model.dart';

import 'package:flutter/cupertino.dart';

class UserNotifier with ChangeNotifier{
  List<Users> _userProfileData = [];

  Users _currentUser;

  List<Users> get userProfileData => _userProfileData;

  Users get currentUser => _currentUser;


  List<Post> _usersPosts = [];

  Post _currentPost;

  List<Post> get usersPosts => _usersPosts;

  Post get currentPost => _currentPost;

  set userProfileData(List<Users> userProfileData) {
    _userProfileData = userProfileData;
    notifyListeners();
  }

  set currentUser(Users user){
    _currentUser = user;
    notifyListeners();
  }

  set usersPosts(List<Post> usersPosts) {
    _usersPosts = usersPosts;
    notifyListeners();
  }

  set currentPost(Post post){
    _currentPost = post;
    notifyListeners();
  }
}