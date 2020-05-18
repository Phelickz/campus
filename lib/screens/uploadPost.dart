import 'dart:io';
import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:campus/services/model.dart';
import 'package:campus/state/authstate.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../services/theme_notifier.dart';
import '../utils/theme.dart';

class UploadPost extends StatefulWidget {
  final _profilePic;
  final _username;
  UploadPost(this._profilePic, this._username);
  @override
  _UploadPostState createState() =>
      _UploadPostState(this._profilePic, this._username);
}

class _UploadPostState extends State<UploadPost> {
  var _darkTheme;
  final _profilePic;
  final _username;
  _UploadPostState(this._profilePic, this._username);

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  File _imageFile;
  File _videoFile;
  String fileName;
  List<Filter> filters = presetFiltersList;

  TextEditingController _textEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Select an image via gallery or camera

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {});
  }

  Future<void> _pickVideo(ImageSource source) async {
    File _selected = await ImagePicker.pickVideo(source: source);
    setState(() {
      _videoFile = _selected;
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
        ));
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  //remove image
  void _clear() {
    setState(() {
      _imageFile = null;
      _videoFile = null;
    });
  }

  // Retrieve lost data b ecause most times after picking an image, the app restarts and loses the image file
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
          _videoFile = response.file;
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

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select'),
            content: Text('Choose a method'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Text('Gallery'),
              ),
              FlatButton(
                onPressed: () {
                  _pickImage(ImageSource.camera);
                },
                child: Text('Camera'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }

  void _showSecondDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select'),
            content: Text('Choose a method'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _pickVideo(ImageSource.gallery);
                },
                child: Text('Gallery'),
              ),
              FlatButton(
                onPressed: () {
                  _pickVideo(ImageSource.camera);
                },
                child: Text('Camera'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    retrieveLostData();
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    // SnackBarService.instance.buildContext = context;
    return Consumer<AuthenticationState>(builder: (builder, authState, child) {
      return Scaffold(
        backgroundColor: _darkTheme ? Colors.grey[900] : Colors.white,
        bottomNavigationBar: BottomAppBar(
          color: _darkTheme ? Colors.black : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    _showDialog(context);
                  }),
              IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () {
                    _showSecondDialog(context);
                  })
            ],
          ),
        ),
        appBar: AppBar(
                    backgroundColor: _darkTheme ? Colors.black : Colors.white,

          title: Text('Upload a post'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.cloud_upload),
                onPressed: () async {
                  final _uid = await Provider.of<AuthenticationState>(context,
                          listen: false)
                      .currentUserId();

                  final form = formKey.currentState;
                  form.save();
                  _imageFile != null
                      ? authState.addPosts(
                          Post(
                              text: _textEditingController.text.isEmpty
                                  ? ''
                                  : _textEditingController.text,
                              likes: 0,
                              comments: 0,
                              createdAt: Timestamp.now(),
                              date: DateTime.now(),
                              time: DateTime.now(),
                              liked: false,
                              location: _currentAddress ?? ''),
                          _uid,
                          _imageFile,
                          _profilePic,
                          _username,
                          null)
                      : authState.addPosts(
                          Post(
                              text: _textEditingController.text.isEmpty
                                  ? ''
                                  : _textEditingController.text,
                              likes: 0,
                              comments: 0,
                              createdAt: Timestamp.now(),
                              date: DateTime.now(),
                              time: DateTime.now(),
                              liked: false,
                              location: _currentAddress ?? ''),
                          _uid,
                          null,
                          _profilePic,
                          _username,
                          _videoFile);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Post Upload Successful!')));
                  Navigator.pop(context);
                })
          ],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: FutureBuilder(
            future: authState.currentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_imageFile != null) {
                  return ListView(
                    children: <Widget>[
                      Image.file(_imageFile),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: _cropImage, child: Icon(Icons.crop)),
                          FlatButton(
                              onPressed: _clear, child: Icon(Icons.refresh)),
                          FlatButton(
                            child: Icon(Icons.edit),
                            onPressed: () {
                              getImage(context);
                            },
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Caption',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'WorkSansSemiBold'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      maxLines: 3,
                                      controller: _textEditingController,
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: 'Say Something...',
                                          hintStyle:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: FlatButton(
                            onPressed: () {
                              _getCurrentLocation(context);
                            },
                            child: Text('Add Location ?')),
                      )
                    ],
                  );
                } else {
                  if (_videoFile != null) {
                    return ListView(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: mounted
                                ? Chewie(
                                    controller: ChewieController(
                                      videoPlayerController:
                                          VideoPlayerController.file(
                                              _videoFile),
                                      aspectRatio: 3 / 2,
                                      autoPlay: true,
                                      looping: true,
                                    ),
                                  )
                                : Container(),
                          ),
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
                                      fillColor: Colors.grey[800],
                                      filled: true,
                                      hintText: 'Say Something...'),
                                )),
                          ),
                        ),
                        Align(
                        alignment: Alignment.bottomLeft,
                        child: FlatButton(
                            onPressed: () {
                              _getCurrentLocation(context);
                            },
                            child: Text('Add Location ?')),
                      )
                      ],
                    );
                  }
                  return SizedBox();
                }
              }
              return CircularProgressIndicator();
            }),
      );
    });
  }

  _getCurrentLocation(context) {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng(context);
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng(context) async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      print(_currentAddress);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your current location is set to ${_currentAddress}',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(e.message, style: TextStyle(color: Colors.red),),
      ));
    }
  }
}
