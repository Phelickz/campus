import 'package:campus/screens/Notification.dart';
import 'package:campus/screens/chatscreen.dart';
import 'package:campus/screens/post.dart';
import 'package:campus/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'search.dart';

class Feedss extends StatefulWidget {
  //  final String uid;

  //  Feedss(this.uid);
  @override
  _FeedssState createState() => _FeedssState();
}

class _FeedssState extends State<Feedss> {
  //  final String uid;
  // _FeedssState(this.uid);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.camera_front, color: Colors.black,), 
            onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Profile()));
            }),
          title: Text('Tryber',
            style: TextStyle(color: Colors.black,
              fontSize: 20,
              fontFamily: 'WorkSansMedium'),),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.locationArrow, color: Colors.red,), 
              onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Chats()));
            })
          ],
        ),
        bottomNavigationBar: BottomAppBar( 
          // color: Colors.red,         
          shape: CircularNotchedRectangle(),
          child: Row(
            
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.home), 
                onPressed: (){}),
              IconButton(
                icon: Icon(Icons.search), 
                onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => Search()));
                }),
              IconButton(
                icon: Icon(Icons.favorite_border), 
                onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Notifications()));
            }),
              IconButton(
                icon: Icon(FontAwesomeIcons.userEdit), 
                onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Profile()));
            }),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Post()));
            },
          backgroundColor: Colors.red,
          child: Icon(Icons.add),),

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.add_a_photo, color: Colors.white,),
                      
                      backgroundColor: Colors.red,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/arqcoaster_2x.png'),
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/photo-1461280360983-bd93eaa5051b.jpeg'),
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/meet_online_couple_sodas_1600.jpg'),
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/login_logo.png'),
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/wpid-11.png'),
                      radius: 30,
                    ),
                    
                  ],
                  ),
              ),
              Divider(),
              SizedBox(height: 10),
              Container(
                height: 500,
                width: 390,
                color: Colors.transparent,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      height: 450,
                      width: 350,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              // decoration: BoxDecoration(
                              //   color: Colors.red,
                              //   borderRadius: BorderRadius.circular(20)
                              // ),
                              child: Card(
                                
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                  ),
                                elevation: 15,
                                color: Colors.white,
                                child: Image.asset('assets/images/IMG_20190412_163310_101.jpg', fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(
                              height: 20
                            ),
                            Row(
                              children: <Widget>[
                                Text('Awa Felix', 
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSansSemiBold'
                                  ),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 180),
                                  child: IconButton(
                                    icon: Icon(Icons.favorite_border), 
                                    onPressed: (){}),
                                ),
                                IconButton(
                                  icon: Icon(Icons.comment), 
                                  onPressed: (){})
                              ],
                            )
                          ],
                        ),
                      ),
                      
                    ),
                    Divider(thickness: 2,),
                    Container(
                      height: 300,
                      width: 350,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              
                              child: Card(
                                
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                  ),
                                elevation: 10,
                                color: Colors.white,
                                child: Image.asset('assets/images/wpid-11.png', fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(
                              height: 20
                            ),
                            Row(
                              children: <Widget>[
                                Text('Awa Felix', 
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSansSemiBold'
                                  ),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 180),
                                  child: IconButton(
                                    icon: Icon(Icons.favorite_border), 
                                    onPressed: (){}),
                                ),
                                IconButton(
                                  icon: Icon(Icons.comment), 
                                  onPressed: (){})
                              ],
                            )
                          ],
                        ),
                      ),
                      
                    ),
                    Divider(thickness: 2,),
                    Container(
                      height: 300,
                      width: 350,
                      child: SingleChildScrollView(
                                              child: Column(
                          children: <Widget>[
                            Container(
                              
                              child: Card(
                                
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                  ),
                                elevation: 10,
                                color: Colors.white,
                                child: Image.asset('assets/images/meet_online_couple_sodas_1600.jpg', fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(
                              height: 20
                            ),
                            Row(
                              children: <Widget>[
                                Text('Awa Felix', 
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSansSemiBold'
                                  ),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 180),
                                  child: IconButton(
                                    icon: Icon(Icons.favorite_border), 
                                    onPressed: (){}),
                                ),
                                IconButton(
                                  icon: Icon(Icons.comment), 
                                  onPressed: (){})
                              ],
                            )
                          ],
                        ),
                      ),
                      
                    ),
                    Divider(thickness: 2,),
                    // Container(
                    //   height: 450,
                    //   width: 350,
                    //   child: Card(
                    //     elevation: 10,
                    //     color: Colors.white,
                    //     child: Image.asset('assets/images/wpid-11.png', fit: BoxFit.cover,),
                    //   ),
                    // ),
                  ],
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