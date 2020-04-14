
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final Firestore _firestore = Firestore.instance;
String error;
String bio = "Hi, I'm new here";

// FireStoreService _fireStoreService;

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

 signOut() {
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

Future<Map<String, String>> signUp(String email, String password, String name,) async {
   try{ AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(), 
      password: password);
      final FirebaseUser user = result.user;

      assert (user != null);
      assert (await user.getIdToken() != null);

      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      userUpdateInfo.photoUrl = 'https://www.kindpng.com/picc/b/78-785827_avatar-png-icon.png';
      await user.updateProfile(userUpdateInfo).then((user){
        _auth.currentUser().then((user) {
         final DocumentReference _documentReference = 
          _firestore.collection('userData').document(user.uid).collection("profile").document();
          _documentReference.setData
            ({
              'email': user.email,
              'username': user.displayName,
              'photoUrl': user.photoUrl,
              'bio': bio,
              'uid' : user.uid,
              'followers': 0,
              'following': 0,
              'documentId' : _documentReference.documentID,
            }).catchError((e){
              print(e);
            });
          }).catchError((e){
            print(e);
          });
        }).catchError((e){
          print(e);
        });
        await user.reload();
        // await _fireStoreService.createUser(user);
      

      print('Account created');
      print('$user.uid');
      return exposeUser(kUsername: user.displayName, kUID: user.uid);   
  } catch(e){
    print(e);
  }
}

  Future<Map<String, String>> signIn(String email, String password,) async {
    
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

Future<String> getUserId() async {
  final FirebaseUser user = await _auth.currentUser();
  if (user!=null){
    return user.uid;
  } return null;
  
}

  