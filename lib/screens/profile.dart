import 'package:campus/services/auth.dart';
import 'package:campus/utilities.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/services/constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(
      builder: (builder, authState, child) {
        var user = authState.currentUser();
        return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,), 
            onPressed: (){
              Navigator.pop(context);
            }),
          actions: <Widget>[
            getAction(context),
          ],
        ),
        body: FutureBuilder(
          future: authState.currentUser(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Container(
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
                  child: Card(
                    elevation: 5,
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
                        Padding(
                          padding: const EdgeInsets.only(left: 170, top: 5),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/images/arqcoaster_2x.png'),
                            radius: 30,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 145),
                          child: Text(snapshot.data.displayName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'WorkSansBold'
                            ),),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 110),
                          child: Text('Something relating to bio or so',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              
                            ),),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 145),
                          child: Text(snapshot.data.email,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'WorkSansBold'
                            ),),
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text('Photos',
                                 style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 ),),
                                Text('456', style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 ))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('Followers', style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 )),
                                Text('456', style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 ))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('Follows', style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 )),
                                Text('456', style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 ))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            child: Image.asset('assets/images/photo-1461280360983-bd93eaa5051b.jpeg', fit: BoxFit.cover,),
                          ),
                        ),
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            child: Image.asset('assets/images/meet_online_couple_sodas_1600.jpg', fit: BoxFit.cover,),
                          ),
                        ),
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            child: Image.asset('assets/images/login_logo.png', fit: BoxFit.cover,),
                          ),
                        ),
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            child: Image.asset('assets/images/wpid-11.png', fit: BoxFit.cover,),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          );
          }
          return CircularProgressIndicator();
      }
        ),
      );
  }
    );
  }
  PopupMenuButton getActions(BuildContext context){
    return PopupMenuButton<DropDownMenuItem>(
          icon: Icon(Icons.more_horiz, color: Colors.black,),
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


  PopupMenuButton getAction (BuildContext context){
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_horiz, color: Colors.black,),
      itemBuilder: (context) => [
        PopupMenuItem(
          
          value: 1,
          
          child: Text('Logout'))
      ],
      onSelected: (value) {
        if (value == 1) {
          Provider.of<AuthenticationState>(context, listen: false).logout();
          gotoLoginScreen(context);
        }
      },
      );
  }
}




class DropDownMenuItem {
  final String title;
  final Icon icon;

  DropDownMenuItem({this.title, this.icon});

}
List<DropDownMenuItem> dropDownList = [
  DropDownMenuItem(title: 'Settings', icon: Icon(Icons.settings, color: Colors.black,),),
  DropDownMenuItem(title: 'Edit Profile', icon: Icon(Icons.edit, color: Colors.black)),
  DropDownMenuItem(title: 'Logout', icon: Icon(Icons.exit_to_app, color: Colors.black)),
  DropDownMenuItem(title: 'Terms and Privacy', icon: Icon(Icons.book, color: Colors.black))
];


class PopupMenuButtonWidget extends StatelessWidget {
  const PopupMenuButtonWidget({
    Key key
  }): super (key: key);
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
                    Padding(padding: EdgeInsets.all(8.0),),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Text(dropDownMenuItem.title))
                  ],
                  
                ),
              );
            }).toList();
          },
        )
      )    
    );
  }
  
}