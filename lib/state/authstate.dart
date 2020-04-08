import 'package:flutter/material.dart';
import 'package:campus/services/auth.dart';
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

  void signup(email, password, username){
    signUp(email, password, username);
  }
  
  void login(email, password,) {
    try{
      signIn(email, password,);
  } catch (e) {
    print(e);
  }
  }

  // void loginTest(email, password){
  //   signInWithEmail(email, password);
  // }

  void logout(){
    clearState();
    signOut();
    notifyListeners();
  }

  currentUser(){
    return getUser();
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
  }

  getCurrentUser(){
    getUser();
    notifyListeners();
  }
} 