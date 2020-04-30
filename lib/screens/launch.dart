import 'package:campus/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Launch extends StatefulWidget {
  @override
  _LaunchState createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
            IconButton(icon: Icon(Icons.navigate_next), 
              onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Launch2()));
            })
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SizedBox(height: 150),

            Center(
              child: Container(
                height: 450,
                width: 350,
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text('MEET', 
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: "WorkSansSemiBold"
                        ),),
                      SizedBox(height: 50),
                      Text('Find Your Friends. Meet New People.\n                Expand your Circle.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "WorkSansMedium",
                          fontWeight: FontWeight.bold,
                          fontSize: 18),),
                          SizedBox(height: 60),
                          Icon(FontAwesomeIcons.meetup, 
                            color: Colors.red,
                            size: 130,)
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 90),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       RaisedButton(onPressed: null),
            //       RaisedButton(
            //         child: Text('Next'),
            //         onPressed: null)
            //     ],
            //   ),
            // )
          ],
        ),
      )
    );
  }
}





class Launch2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.arrow_back),
             onPressed: (){Navigator.pop(context);}),
            IconButton(icon: Icon(Icons.navigate_next), 
              onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Launch3()));
            })
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SizedBox(height: 150),

            Center(
              child: Container(
                height: 450,
                width: 350,
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text('CONNECT', 
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: "WorkSansSemiBold"
                        ),),
                      SizedBox(height: 50),
                      Text('Expand Your Network. Share Ideas.\n           Explore, Discover, Live.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "WorkSansMedium",
                          fontWeight: FontWeight.bold,
                          fontSize: 18),),
                          SizedBox(height: 60),
                          Icon(FontAwesomeIcons.connectdevelop, 
                            color: Colors.red,
                            size: 130,)
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 90),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       RaisedButton(onPressed: null),
            //       RaisedButton(
            //         child: Text('Next'),
            //         onPressed: null)
            //     ],
            //   ),
            // )
          ],
        ),
      )
    );
  }
}



class Launch3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.arrow_back),
             onPressed: (){Navigator.pop(context);}),
            IconButton(icon: Icon(Icons.navigate_next), 
              onPressed: () {
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => LoginScreen()));
            })
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SizedBox(height: 150),

            Center(
              child: Container(
                height: 450,
                width: 350,
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text('LOVE', 
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: "WorkSansSemiBold"
                        ),),
                      SizedBox(height: 50),
                      Text('Admire Someone. Get Noticed.\n         Meet, Connect, Love.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "WorkSansMedium",
                          fontWeight: FontWeight.bold,
                          fontSize: 18),),
                          SizedBox(height: 60),
                          Icon(FontAwesomeIcons.wifi, 
                            color: Colors.red,
                            size: 130,)
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 90),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       RaisedButton(onPressed: null),
            //       RaisedButton(
            //         child: Text('Next'),
            //         onPressed: null)
            //     ],
            //   ),
            // )
          ],
        ),
      )
    );
  }
}