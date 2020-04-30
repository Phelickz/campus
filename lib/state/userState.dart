

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


  List<Post> _usersPostsWithId =[];
  Post _currentPostWithId;
  List<Post> get usersPostsWithId => _usersPostsWithId;
  Post get currentPostWithId => _currentPostWithId;


  List<Feeds> _userFeeds = [];

  Feeds _currentFeed;

  List<Feeds> get userFeeds => _userFeeds;

  Feeds get currentFeed => _currentFeed;


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

  set usersPostsWithId(List<Post> usersPostsWithId){
    _usersPostsWithId = usersPostsWithId;
    notifyListeners();
  }

  set currentPostWithid(Post postWithId){
    _currentPostWithId = postWithId;
    notifyListeners();
  }
  
  set userFeeds(List<Feeds> userFeeds){
    _userFeeds = userFeeds;
    notifyListeners();
  }

  set currentFeed(Feeds feed){
    _currentFeed = feed;
    notifyListeners();
  }
}