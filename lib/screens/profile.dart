import 'dart:async';
import 'package:campus/screens/feedss.dart';
import 'package:campus/screens/uploadPost.dart';
import 'package:campus/services/model.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:campus/screens/editProfile.dart';
import 'package:campus/services/firestore.dart';
import 'package:campus/state/userState.dart';
import 'package:campus/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus/state/authstate.dart';

import 'chatscreen.dart';
import 'profileEdit.dart';
import 'settings.dart';

class Profile extends StatefulWidget {
  final uid;
  Profile(this.uid);
  @override
  _ProfileState createState() => _ProfileState(this.uid);
}

class _ProfileState extends State<Profile> {
  var _darkTheme;
  String profilePic;
  String username;
  Color _colors = Colors.black;
  Color _background = Colors.grey[200];
  final uid;
  _ProfileState(this.uid);
  final Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUsersData(userNotifier, uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final orientation = MediaQuery.of(context).orientation;
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    final auth = Provider.of<AuthenticationState>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   // userNotifier.currentUser = userNotifier.userProfileData[index];
        // }),
        bottomNavigationBar: BottomAppBar(
          color: _darkTheme ? Colors.black : Colors.grey[200],

          // color: Colors.red,
          shape: CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white38 : Colors.black38,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    // elevation: _darkTheme ? 40 : 10,
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
                ),
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white54 : Colors.black38,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    // elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () async {
                        final user = await Provider.of<AuthenticationState>(
                                context,
                                listen: false)
                            .currentUserId();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(user)));
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(FontAwesomeIcons.userAstronaut,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white38 : Colors.black38,
                          
                          // color: _darkTheme ? Colors.white : Colors.black,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () async {
                        final _uid = await Provider.of<AuthenticationState>(
                                context,
                                listen: false)
                            .currentUserId();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => Home(uid)));
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(Icons.chat_bubble, color: _colors),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white38 : Colors.black38,

                          // color: _darkTheme ? Colors.white : Colors.black,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child:
                            Icon(Icons.notification_important, color: _colors),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        new BoxShadow(
                          color: _darkTheme ? Colors.white38 : Colors.black38,

                          // color: _darkTheme ? Colors.white : Colors.black,
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Card(
                    elevation: 10,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: _background,
                        radius: 20,
                        child: Icon(Icons.settings, color: _colors),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              height: 320,
              width: MediaQuery.of(context).size.width,
              // color: Colors.red,
              child: Stack(
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
                        onTap: () {},
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
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: userNotifier.userProfileData.length,
                        // physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var item = userNotifier.userProfileData[index];
                          
                          // setState(() {
                          //   profilePic = item.photoUrl;
                          //   username = item.username;
                          // });
                          return Container(
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
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                              UploadPost(
                                                                  profilePic,
                                                                  username)));
                                                });
                                              },
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(item.photoUrl),
                                                radius: 30,
                                                backgroundColor:
                                                    Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0),
                                              child: CircleAvatar(
                                                radius: 12,
                                                child: IconButton(
                                                    icon: Icon(Icons.edit,
                                                        size: 15),
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
                                                                      item.phone)));
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
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(item.followers,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text('Followers',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white60,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(item.following,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text('Following',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white60,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 270),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        color: _darkTheme ? Colors.black : Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.only(left: 180, top: 10),
                          child: Text(
                            'Posts',
                            style: TextStyle(
                                color: _darkTheme ? Colors.white : Colors.black,
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Container(
              color: Colors.grey[200],
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<Post>>(
                      stream: auth.getPostsWithIDS(uid),
                      builder: (context, snapshot) {
                        var _data = snapshot.data;
                        return snapshot.hasData
                            ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: _data.length,
                                padding: EdgeInsets.only(top: 0),
                                physics: ClampingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: (orientation ==
                                                Orientation.landscape)
                                            ? 2
                                            : 3),
                                itemBuilder: (BuildContext context, int index) {
                                  return Image.network(
                                    _data[index].photoUrl,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : CircularProgressIndicator();
                      }),
                ],
              )),
          // Container(
          //   height: 300,
          //   width: MediaQuery.of(context).size.width,
          //   child: Card(
          //     elevation: 10,
          //     color: Colors.white,
          //     child: Image.asset('assets/images/photo-1461280360983-bd93eaa5051b.jpeg', fit: BoxFit.cover,),
          //   ),
          // ),
          // Container(
          //   height: 300,
          //   width: MediaQuery.of(context).size.width,
          //   child: Card(
          //     elevation: 10,
          //     color: Colors.white,
          //     child: Image.asset('assets/images/meet_online_couple_sodas_1600.jpg', fit: BoxFit.cover,),
          //   ),
          // ),
          // Container(
          //   height: 300,
          //   width: MediaQuery.of(context).size.width,
          //   child: Card(
          //     elevation: 10,
          //     color: Colors.white,
          //     child: Image.asset('assets/images/login_logo.png', fit: BoxFit.cover,),
          //   ),
          // ),
          // Container(
          //   height: 300,
          //   width: MediaQuery.of(context).size.width,
          //   child: Card(
          //     elevation: 10,
          //     color: Colors.white,
          //     child: Image.asset('assets/images/wpid-11.png', fit: BoxFit.cover,),
          //   ),
          // ),
        ])),
      ),
    );
  }

  PopupMenuButton getActions(BuildContext context) {
    return PopupMenuButton<DropDownMenuItem>(
      icon: Icon(
        Icons.more_horiz,
        color: Colors.black,
      ),
      onSelected: ((valueSelected) {
        print('valueSelected : ${valueSelected.title}');
      }),
      itemBuilder: (BuildContext context) {
        return dropDownList.map((DropDownMenuItem dropDownMenuItem) {
          return PopupMenuItem<DropDownMenuItem>(
            value: dropDownMenuItem,
            child: Row(
              children: <Widget>[
                // Icon(dropDownMenuItem.icon.icon),
                // Padding(padding: EdgeInsets.all(8.0),),
                Text(dropDownMenuItem.title)
              ],
            ),
          );
        }).toList();
      },
    );
  }

  PopupMenuButton getAction(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_horiz,
        color: Colors.black,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(value: 0, child: Text('Edit Profile')),
        PopupMenuItem(value: 1, child: Text('Logout')),
      ],
      onSelected: (value) {
        if (value == 1) {
          Provider.of<AuthenticationState>(context, listen: false).logout();
          gotoLoginScreen(context);
        } else if (value == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfile()));
          });
        }
      },
    );
  }

  Stream<QuerySnapshot> getUsersDataSnapshots(BuildContext context) async* {
    final uid = await Provider.of<AuthenticationState>(context, listen: false)
        .currentUserId();
    yield* _firestore
        .collection('userData')
        .document(uid)
        .collection('profile')
        .snapshots();
  }
}

class DropDownMenuItem {
  final String title;
  final Icon icon;

  DropDownMenuItem({this.title, this.icon});
}

List<DropDownMenuItem> dropDownList = [
  DropDownMenuItem(
    title: 'Settings',
    icon: Icon(
      Icons.settings,
      color: Colors.black,
    ),
  ),
  DropDownMenuItem(
      title: 'Edit Profile', icon: Icon(Icons.edit, color: Colors.black)),
  DropDownMenuItem(
      title: 'Logout', icon: Icon(Icons.exit_to_app, color: Colors.black)),
  DropDownMenuItem(
      title: 'Terms and Privacy', icon: Icon(Icons.book, color: Colors.black))
];

class PopupMenuButtonWidget extends StatelessWidget {
  const PopupMenuButtonWidget({Key key}) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(75.0);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        height: preferredSize.height,
        width: double.infinity,
        child: Center(
            child: PopupMenuButton<DropDownMenuItem>(
          icon: Icon(Icons.view_list),
          onSelected: ((valueSelected) {
            print('valueSelected : ${valueSelected.title}');
          }),
          itemBuilder: (BuildContext context) {
            return dropDownList.map((DropDownMenuItem dropDownMenuItem) {
              return PopupMenuItem<DropDownMenuItem>(
                value: dropDownMenuItem,
                child: Row(
                  children: <Widget>[
                    Icon(dropDownMenuItem.icon.icon),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                        onTap: () {}, child: Text(dropDownMenuItem.title))
                  ],
                ),
              );
            }).toList();
          },
        )));
  }
}
