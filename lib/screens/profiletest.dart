import 'package:campus/screens/feedss.dart';
import 'package:campus/screens/uploadPost.dart';
import 'package:campus/services/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:campus/services/firestore.dart';
import 'package:campus/state/userState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus/state/authstate.dart';

// import 'post.dart';
import 'profile.dart';
import 'profileEdit.dart';

class ProfileTest extends StatefulWidget {
  final uid;
  ProfileTest(this.uid);
  @override
  _ProfileTestState createState() => _ProfileTestState(this.uid);
}

class _ProfileTestState extends State<ProfileTest> {
  String profilePic;
  String username;
  Color _colors = Colors.black;
  Color _background = Colors.grey[200];
  final uid;
  _ProfileTestState(this.uid);
  final Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUsersData(userNotifier, uid);
    getUsersPostsWithId(userNotifier, uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    final auth = Provider.of<AuthenticationState>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   // userNotifier.currentUser = userNotifier.userProfileData[index];
      // }),
      bottomNavigationBar: BottomAppBar(
        color: _background,
        // color: Colors.red,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Card(
                elevation: 10,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Feedss()));
                  },
                  child: CircleAvatar(
                    backgroundColor: _background,
                    radius: 20,
                    child: Icon(
                      Icons.home,
                      color: _colors,
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () async {
                    final user = await Provider.of<AuthenticationState>(context,
                            listen: false)
                        .currentUserId();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile(user)));
                  },
                  child: CircleAvatar(
                    backgroundColor: _background,
                    radius: 20,
                    child: Icon(FontAwesomeIcons.userAstronaut,
                        color: Colors.blue),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: _background,
                    radius: 20,
                    child: Icon(Icons.chat_bubble, color: _colors),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: _background,
                    radius: 20,
                    child: Icon(Icons.notification_important, color: _colors),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: _background,
                    radius: 20,
                    child: Icon(Icons.settings, color: _colors),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        // scrollDirection: ScrollPhysics(),
        slivers: <Widget>[
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            var item = userNotifier.userProfileData[index];
            return Stack(
              children: <Widget>[
                Container(
                  height: 320,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/image.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  left: 25,
                  top: 25,
                  child: Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => UploadPost(item.photoUrl, item.username)));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 15,
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: Text(
                    'New Post',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'WorkSansBold'),
                  ),
                ),
                Positioned(
                    top: 18.0,
                    bottom: 10.0,
                    left: 10.0,
                    right: 10.0,
                    child:
                        // setState(() {
                        //   profilePic = item.photoUrl;
                        //   username = item.username;
                        // });
                        Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 280,
                      width: MediaQuery.of(context).size.width,
                      // decoration: BoxDecoration(
                      //   boxShadow: [
                      //       BoxShadow(
                      //         spreadRadius: 0.0,
                      //         color: Colors.grey,
                      //         offset: Offset(1.0, 0.75),
                      //         blurRadius: 1.0
                      //       )
                      //     ],
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.only(
                      //     bottomLeft: Radius.circular(15),
                      //     bottomRight: Radius.circular(15)
                      //   )
                      // ),
                      child: Container(
                        color: Colors.transparent,

                        // elevation: 5,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Padding(
                              //   padding: const EdgeInsets.only(left:8.0),
                              //   child: Text('My Profile',
                              //     style: TextStyle(
                              //       fontSize: 25,
                              //       fontWeight: FontWeight.bold,
                              //       fontFamily: 'WorkSansSemiBold'
                              //     ),),
                              // ),
                              // SizedBox(height: 20,),
                              Align(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            profilePic = item.photoUrl;
                                            username = item.username;
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        UploadPost(profilePic,
                                                            username)));
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(item.photoUrl),
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 30.0),
                                        child: CircleAvatar(
                                          radius: 12,
                                          child: IconButton(
                                              icon: Icon(Icons.edit, size: 15),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            ProfileEdit(
                                                                EditMode
                                                                    .Editing,
                                                                item.username,
                                                                item.bio,
                                                                item.email,
                                                                item.phone,
                                                                item.photoUrl)));
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              Align(
                                child: Text(
                                  item.username,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'WorkSansBold'),
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                child: Text(
                                  item.email,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                child: Text(
                                  item.bio,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'WorkSansBold'),
                                ),
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        '456',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Photos',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white60,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(item.followers,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text('Followers',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white60,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(item.following,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text('Following',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white60,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                Positioned(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 270),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 180, top: 10),
                        child: Text(
                          'Posts',
                          style: TextStyle(
                              fontFamily: 'WorkSansSemiBold', fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }, childCount: userNotifier.userProfileData.length)),
          StreamBuilder<List<Post>>(
            stream: auth.getPostsWithIDS(uid),
            builder: (context, _snapshot) {
              var _data = _snapshot.data;
              return _snapshot.hasData ?
              SliverGrid(
                
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (orientation == Orientation.landscape) ? 2 : 3),
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int index) {
                  
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.blue,
                        child: Image.network(
                            _data[index].photoUrl));
                  
                  
                }, childCount: _data.length),
              ): null;
            }
          )
        ],
      ),
    );
  }
}
