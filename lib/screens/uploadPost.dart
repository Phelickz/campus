import 'dart:io';
import 'dart:async';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:campus/services/model.dart';
import 'package:campus/state/authstate.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';



class UploadPost extends StatefulWidget {
  final _profilePic;
  final _username;
  UploadPost(this._profilePic, this._username);
  @override
  _UploadPostState createState() => _UploadPostState(this._profilePic, this._username);
}

class _UploadPostState extends State<UploadPost> {
  final _profilePic;
  final _username;
  _UploadPostState(this._profilePic, this._username);

  File _imageFile;
  String fileName;
  List<Filter> filters = presetFiltersList;

  TextEditingController _textEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  
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
      return;
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

  Future getImage(context) async {
    fileName = basename(_imageFile.path);
    var image = imageLib.decodeImage(_imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
     Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
              title: Text("Edit Photo"),
              image: image,
              filters: presetFiltersList,
              filename: fileName,
              loader: Center(child: CircularProgressIndicator()),
              fit: BoxFit.contain,
            ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        _imageFile = imagefile['image_filtered'];
      });
      print(_imageFile.path);
    }
  }
  @override
  Widget build(BuildContext context) {
    retrieveLostData();
    // SnackBarService.instance.buildContext = context;
    return Consumer<AuthenticationState>(
      builder: (builder, authState, child){
          return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera), 
                  onPressed: (){_pickImage(ImageSource.camera);}
                  ),
                IconButton(
                  icon: Icon(Icons.photo_library), 
                  onPressed: (){_pickImage(ImageSource.gallery);})
              ],
            ),
          ),
        appBar: AppBar(
          
          backgroundColor: Colors.red,
          title: Text('Upload a post'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.cloud_upload), 
              onPressed: () async{
              final _uid = await Provider.of<AuthenticationState>(context, listen: false).currentUserId();

                final form = formKey.currentState;
                form.save();
                authState.addPosts(
                  Post(
                    text: _textEditingController.text.isEmpty ? '' : _textEditingController.text,
                    likes: 0,
                    comments: 0,
                    createdAt: Timestamp.now(),
                    date: DateTime.now(),
                    time: DateTime.now(),
                    liked: false
                  ), _uid, _imageFile, _profilePic, _username, null);
                   Navigator.pop(context);
              })
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), 
            onPressed: (){
              Navigator.pop(context);
            }),
        ),
        body: FutureBuilder(
            future: authState.currentUser(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if (_imageFile != null) {
                  return ListView(
                  children: <Widget>[
                    
                      Image.file(_imageFile),  
                      

                      Row(
                        
                        children: <Widget>[
                          FlatButton(
                            onPressed: _cropImage, 
                            child: Icon(Icons.crop)
                            ),
                          FlatButton(
                            onPressed: _clear, 
                            child: Icon(Icons.refresh)
                            ),
                          FlatButton(
                            child: Icon(Icons.edit),
                            onPressed: (){getImage(context);},)
                        ],
                        
                        ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              maxLines: 3,
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Say Something...'
                              ),
                            )
                            ),
                        ),
                      )
                    
                  ],
                );
                } return SizedBox(height: 0);
            } return CircularProgressIndicator();
            }
          ),
      );}
    );
  }
}