import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'profile.dart';
import 'search.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(          
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.home), 
                onPressed: (){
              // Navigator.push(context, 
              // MaterialPageRoute(builder: (context) => Feedss()));
            }),
              IconButton(
                icon: Icon(Icons.search), 
                onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => Search()));
                }),
              IconButton(
                icon: Icon(Icons.favorite_border), 
                onPressed: (){}),
              IconButton(
                icon: Icon(FontAwesomeIcons.userEdit), 
                onPressed: (){
              // Navigator.push(context, 
              // MaterialPageRoute(builder: (context) => Profile()));
            }),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.red,
          child: Icon(Icons.add),),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('Notifications',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSansSemiBold'
                  ),),
              ),
              Divider(),
              Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('Nicole Gray liked your photo', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20
                                  ),),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, top: 5),
                              //   child: Text('hello there?'),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('5.25pm'),
                          )
                        ],
                      ),
                    ),
                  ),
            ],
          ),        
        ),
            ],
    ))));
  }
}