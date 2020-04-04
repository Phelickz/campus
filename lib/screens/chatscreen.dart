import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,), 
          onPressed: (){
            Navigator.pop(context);
          }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.unfold_more), 
            onPressed: null)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[400],
        child: Icon(Icons.chat_bubble),
        onPressed: null),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text('Conversation',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSansBold'),
                  ),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRect(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 5.0
                    )
                  ]
                ),
                height: 50,
                margin: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.pink[400],
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.pink[400],),
                    hintText: 'Search Conversation',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300
                    ),
                    // border: OutlineInputBorder(
                      
                    //   borderRadius: BorderRadius.circular(25),
                    //   borderSide: BorderSide()
                    // )
                  ),
                ),
              ),
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
                                child: Text('Nicole Gray', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('hello there?'),
                              )
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
                  Divider(),
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
                                child: Text('Allison Becker', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('where are you from?'),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('1.22pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
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
                                child: Text('Jamie Elba', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('where do you school?'),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('2.15am'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
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
                                child: Text('Berry Alley', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('hi there?'),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('9.45pm'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
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
                                child: Text('Nicole Gray', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('hello there?'),
                              )
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
                  Divider(),
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
                                child: Text('Nicole Gray', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('hello there?'),
                              )
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
                  Divider(),
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
                                child: Text('Nicole Gray', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('hello there?'),
                              )
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
                  Divider(),
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
                                child: Text('Nicole Gray', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('hello there?'),
                              )
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
                  Divider(),
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
                                child: Text('Nicole Gray', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('hello there?'),
                              )
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
                  Divider(),
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
                                child: Text('Nicole Gray', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 5),
                                child: Text('hello there?'),
                              )
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
            )
          ],
        ),
      ),
    );
  }
}