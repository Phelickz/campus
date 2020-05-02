import 'package:campus/screens/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class ViewVideo extends StatefulWidget {

  final _videoUrl;
  ViewVideo(this._videoUrl);
  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Material(
          child: Container(
            child: FittedBox(
              fit: BoxFit.contain,
              child: mounted
                  ? ChewieListItem(
                    
                      videoPlayerController: VideoPlayerController.network(
                          this.widget._videoUrl),
                      looping: false,
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
