import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();


Map<String, String> exposeUser({@required kUsername, @required kUID}) {
  print(kUID);
  return {
    kUsername : kUsername,
    kUID: kUID
  };
}

Future<Map<String, String>> getCurrentUser() async{
  final FirebaseUser user = await _auth.currentUser();
  if (user != null){
    return exposeUser(kUsername: user.displayName, kUID: user.uid);
    // print(user.getIdToken());
    // return user.uid;
  }
  return null;
}

Future getUser() async {
  final FirebaseUser user = await _auth.currentUser();
  return user;
}

Future<bool> isUserSignedIn() async {
  final FirebaseUser currentUser = await _auth.currentUser();
  return currentUser != null;
}

void signOut() {
  try{
    _auth.signOut();
  } catch (error) {
    print(error);
  }
}

void onAuthenticationChange(Function isLogin) {
  _auth.onAuthStateChanged.listen((FirebaseUser user){
    if (user != null) {
      isLogin(exposeUser(kUsername: user.displayName, kUID: user.uid));
    }else {
      isLogin(null);
    }
  });
}

Future<Map<String, String>> signUp(String email, String password, String name) async {
   try{ AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(), 
      password: password);
      final FirebaseUser user = result.user;

      assert (user != null);
      assert (await user.getIdToken() != null);

      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      await user.updateProfile(userUpdateInfo);
      await user.reload();


      print('Account created');
      print('$user.uid');
      return exposeUser(kUsername: user.displayName, kUID: user.uid);   
  } catch(e){
    print(e);
  }
}

  Future<Map<String, String>> signIn(String email, String password,) async {
    String error;
   try{ AuthResult result = await _auth.signInWithEmailAndPassword(
      email: email.trim(), 
      password: password);
      final FirebaseUser user = result.user;
      assert(user != null);
      assert (await user.getIdToken() != null);

      final FirebaseUser currentUser =await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      print('signIn succeeded : $user');
      print('User signed in');
      return exposeUser(kUsername: user.displayName, kUID: user.uid);
  } catch (e){
    error = e.message;
    print(error);
  }
  }
  
  //  handleError(PlatformException error) {
  //   print(error);
  //   switch (error.code) {
  //     case 'ERROR_EMAIL_ALREADY_IN_USE':
  //       setState(() {
  //         errorMessage = 'Email Id already Exist!!!';
  //       });
  //       break;
  //     default:
  //   }
  // }


Future sendPasswordResetEmail(String email) async {
  return _auth.sendPasswordResetEmail(email: email.trim());
}


  