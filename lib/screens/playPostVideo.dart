import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'videoPlayer.dart';

class PlayVideo extends StatefulWidget {
  final _videoUrl;

  PlayVideo(this._videoUrl);
  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
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
    );
  }
}
