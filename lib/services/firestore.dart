import 'package:cloud_firestore/cloud_firestore.dart';


class UserManagement {
  storeNewUser(user) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'username': user.displayName,
      'photoUrl': user.photoUrl,
      'bio': user.bio  
    }).catchError((e){
      print(e);
    });

  }
}