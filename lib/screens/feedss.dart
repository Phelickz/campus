import 'package:campus/screens/Notification.dart';
import 'package:campus/screens/chatscreen.dart';
import 'package:campus/screens/post.dart';
import 'package:campus/screens/profile.dart';
import 'package:campus/screens/uploadPost.dart';
import 'package:campus/state/userState.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:campus/services/firestore.dart'; 
import 'package:timeago/timeago.dart' as timeago;

import 'search.dart';
import 'package:campus/state/authstate.dart';

class Feedss extends StatefulWidget {
  //  final String uid;

  //  Feedss(this.uid);
  @override
  _FeedssState createState() => _FeedssState();
}

class _FeedssState extends State<Feedss> {

  Color _colors = Colors.black;
  Color _background = Colors.grey[200];
  //  final String uid;
  // _FeedssState(this.uid);

  @override
  void initState() {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
    getUsersPosts(userNotifier);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: _background,
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
                    onTap: (){},
                    child: CircleAvatar(
                      backgroundColor: _background,
                      radius: 20,
                      child: Icon(Icons.home, color: Colors.blue,),
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  shape: CircleBorder(),
                  child: InkWell(
                    onTap: () async {
                      final user = await Provider.of<AuthenticationState>(context, listen: false).currentUserId();
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => Profile(user)));
                      },
                    child: CircleAvatar(
                      backgroundColor: _background,
                      radius: 20,
                      child: Icon(FontAwesomeIcons.userAstronaut, color: _colors),
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  shape: CircleBorder(),
                  child: InkWell(
                    onTap: (){},
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
                    onTap: (){},
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
                    onTap: (){},
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
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){
        //       Navigator.push(context, 
        //       MaterialPageRoute(builder: (context) => UploadPost()));
        //     },
        //   backgroundColor: Colors.red,
        //   child: Icon(Icons.add),),

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: _background,
                height: 50,
                width: double.infinity,
                child:  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        height: 50,
                        width: 100,
                        color: Colors.transparent,
                        
                        child: RaisedButton(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 65),
                            child: Row(
                              children: <Widget>[
                                Icon(FontAwesomeIcons.fire, color: Colors.red,),
                                Text('Discover People!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,         
                                    color: Colors.black
                                  ),
                                ),
                                Icon(FontAwesomeIcons.fire, color: Colors.red,),
                              ],
                            ),
                          ), 
                            
                          color: Colors.white,
                          onPressed: (){    
                          } 
                          ),
                      ),
                    )
              ),
              // Divider(),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.transparent,
                child: ListView.builder(
                  itemCount: userNotifier.usersPosts.length,
                  physics: BouncingScrollPhysics(),

                  
                    // Container(
                    //   height: 60,
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.only(left: 20),
                    //   child: ListView(
                    //     physics: BouncingScrollPhysics(),
                    //     scrollDirection: Axis.horizontal,
                    //     children: <Widget>[
                    //       CircleAvatar(
                    //         child: Icon(Icons.add_a_photo, color: Colors.white,),
                            
                    //         backgroundColor: Colors.red,
                    //         radius: 30,
                    //       ),
                          
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: CircleAvatar(
                    //           backgroundImage: AssetImage('assets/images/arqcoaster_2x.png'),
                    //           radius: 30,
                    //         ),
                    //       ),
                          
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: CircleAvatar(
                    //           backgroundImage: AssetImage('assets/images/photo-1461280360983-bd93eaa5051b.jpeg'),
                    //           radius: 30,
                    //         ),
                    //       ),
                          
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: CircleAvatar(
                    //           backgroundImage: AssetImage('assets/images/meet_online_couple_sodas_1600.jpg'),
                    //           radius: 30,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: CircleAvatar(
                    //           backgroundImage: AssetImage('assets/images/login_logo.png'),
                    //           radius: 30,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: CircleAvatar(
                    //           backgroundImage: AssetImage('assets/images/wpid-11.png'),
                    //           radius: 30,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: CircleAvatar(
                    //           backgroundImage: AssetImage('assets/images/wpid-11.png'),
                    //           radius: 30,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: CircleAvatar(
                    //           backgroundImage: AssetImage('assets/images/wpid-11.png'),
                    //           radius: 30,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: CircleAvatar(
                    //           backgroundImage: AssetImage('assets/images/wpid-11.png'),
                    //           radius: 30,
                    //         ),
                    //       ),
                    //     ],
                    //     ),
                    // ),
                  itemBuilder: (BuildContext context, int index){
                    var _item = userNotifier.usersPosts[index];
                    final time = DateTime.now();
                    final postTime = userNotifier.usersPosts[index].date;
                    final difference = time.difference(postTime);
                    var newtime = timeago.format(time.subtract(difference), locale: 'en');
                    if (userNotifier.usersPosts.isNotEmpty) {
                    return Container(
                      height: 600,
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, top: 10),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(_item.profilePic),
                                      radius: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                       children: <Widget>[
                                         Text(_item.username, 
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                          ),),
                                         Row(
                                           children: <Widget>[
                                             Icon(Icons.location_on, color: Colors.black45,),
                                             Text('Benin City')
                                           ],
                                         )
                                       ], 
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              
                                // decoration: BoxDecoration(
                                //   color: Colors.red,
                                //   borderRadius: BorderRadius.circular(20)
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 370,
                                    child: Card(
                                      
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)
                                        ),
                                      elevation: 0,
                                      color: Colors.white,
                                      child: Image.network(_item.photoUrl,
                                       fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                              
                              SizedBox(
                                height: 10
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(_item.text, 
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200,
                                        fontFamily: 'WorkSansSemiBold'
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0, right:10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.favorite,
                                                color: Colors.red,),
                                              onPressed: (){}),
                                            Text('${_item.likes} likes'),
                                          ],
                                          ),
                                          Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.mode_comment,
                                                color: Colors.blue,),
                                              onPressed: (){}),
                                            Text('${_item.comments} comments'),
                                          ],
                                          ),
                                          Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.timer,
                                                color: Colors.red,),
                                              onPressed: (){}),
                                            Text('${newtime}'),
                                          ],
                                          ),
                                      ],),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      
                    );
                  } return CircularProgressIndicator();
                  }         
                ),
              )
              // ListView(
              //   children: <Widget>[
              //     Text('data'),
              //     Text('data')
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}