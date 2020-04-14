import 'package:campus/state/authstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _bioController = TextEditingController();
    //  var width = double.infinity;
    return Consumer<AuthenticationState>(
      builder: (builder, authState, child){
        return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Edit Profile', 
            style: TextStyle(
              color: Colors.black
            ),),
         elevation: 0,
         backgroundColor: Colors.white,
         leading: IconButton(
           icon: Icon(Icons.arrow_back_ios, color: Colors.black), 
           onPressed: (){
             Navigator.pop(context);
           }),
        ),
        body: FutureBuilder(
          future: authState.currentUser(),
          builder: (context, snapshot) {
          if (snapshot.hasData){
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  
                  padding: const EdgeInsets.only(
                    left: 140
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                       MaterialPageRoute(builder: (context) => ImageCapture()));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('${snapshot.data.photoUrl}'),
                      radius: 70,
                      // backgroundColor: Colors.red,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     top: 20,
                //     left: 100
                //   ),
                //   child: Row(
                //     children: <Widget>[
                //       CircleAvatar(
                //        radius: 70,
                //        backgroundColor: Colors.red, 
                //       ),
                //       IconButton(
                //         hoverColor: Colors.red,
                //         highlightColor: Colors.red,
                //         icon: Icon(Icons.photo, color: Colors.black,),
                //         onPressed: (){_pickImage(ImageSource.gallery);}),
                //       IconButton(
                //         hoverColor: Colors.red,
                //         highlightColor: Colors.red,
                //         icon: Icon(Icons.add_a_photo, color: Colors.black,), 
                //         onPressed: (){_pickImage(ImageSource.camera);})
                //     ],
                //   ),
                // ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Username', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),),
                        TextFormField(
                          
                          controller: _usernameController,
                          decoration: InputDecoration(
                             hintText: '${snapshot.data.displayName}',
                                
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height:15),
                        Text('Email', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),),
                        TextFormField(
                          
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: '${snapshot.data.email}',
                                
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height:15),
                        Text('Bio', 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),),
                        TextFormField(
                          
                          controller: _bioController,
                          decoration: InputDecoration(
                            // hintText: 'Bio',
                                
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 150,
                    top: 30
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    height: 50,
                    width: 100,
                    child: RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.update),
                          
                          Text('Save')
                        ],
                      ),
                      elevation: 5,
                      color: Colors.red,
                      onPressed: (){}),
                  ),
                )
              ],
            ),
          );
          } return CircularProgressIndicator();
          }
        ),
      );}
    );
  }

  //Cropper plugin


  
}


class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  
  File _imageFile;

  
  
  // Select an image via gallery or camera

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      
    });
  }

  //Cropper plugin

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      )
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  //remove image
  void _clear(){
    setState(() {
      _imageFile=null;
    });
  }

  // Retrieve lost data b ecause most times after picking an image, the app restarts and loses the image file
  Future<void> retrieveLostData() async {
    final LostDataResponse response =
        await ImagePicker.retrieveLostData();
    if (response == null) {
      return null;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
          _imageFile = response.file;
        } else {
          _imageFile = response.file;
        }
      });
    } else {
      print(response.exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final id = Provider.of<AuthenticationState>(context, listen: false).currentUserId();
    retrieveLostData();
    return Consumer<AuthenticationState>(
      builder: (builder, authState, child){
        
        return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () async{
                final id = await Provider.of<AuthenticationState>(context, listen: false).currentUserId();
                authState.updateProfilePicture(id, _imageFile).then((user){
                Navigator.pop(context);
                });
              },)
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), 
            onPressed: (){
              
                Navigator.pop(context);
              
            }),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera), 
                onPressed: () => _pickImage(ImageSource.camera)
                ),
              IconButton(
                icon: Icon(Icons.photo_library), 
                onPressed: () => _pickImage(ImageSource.gallery))
            ],
          ),
        ),
        body: FutureBuilder(
          future: authState.currentUser(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              if (_imageFile != null) {
                return ListView(
                children: <Widget>[
                  
                    Image.file(_imageFile),  
                    

                    Row(
                      
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => _cropImage(), 
                          child: Icon(Icons.crop)
                          ),
                        FlatButton(
                          onPressed: () => _clear(), 
                          child: Icon(Icons.refresh)
                          ),
                      ],
                      
                      )
                  
                ],
              );
              } return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${snapshot.data.photoUrl}'))
                ),
              );
          } return CircularProgressIndicator();
          }
        ),
      );}
    );
  }
} 