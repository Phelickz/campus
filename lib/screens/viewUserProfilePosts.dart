import 'package:campus/services/model.dart';
import 'package:campus/state/authstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'playPostVideo.dart';

class ViewUserPosts extends StatefulWidget {
  final uid;
  ViewUserPosts(this.uid);
  @override
  _ViewUserPostsState createState() => _ViewUserPostsState();
}

class _ViewUserPostsState extends State<ViewUserPosts> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthenticationState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploads'),
      ),
      body: StreamBuilder<List<Post>>(
          stream: _auth.getPostsWithIDS(this.widget.uid),
          builder: (context, snapshot) {
            var _data = snapshot.data;
            return snapshot.hasData
                ? StaggeredGridView.countBuilder(
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: 4,
                    itemCount: _data.length,
                    staggeredTileBuilder: (int index) =>
                        StaggeredTile.count(2, index.isEven ? 2 : 1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    itemBuilder: (BuildContext context, int index) {
                      var _item = _data[index];
                      return _item.photoUrl != null
                          ? GestureDetector(
                              onTap: () {},
                              child: Image.network(_item.photoUrl))
                          : IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                size: 40,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlayVideo(_item.videoUrl)));
                              },
                            );
                    })
                : CircularProgressIndicator();
          }),
    );
  }
}
