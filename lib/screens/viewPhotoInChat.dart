import 'package:flutter/material.dart';

class ViewPhoto extends StatelessWidget {
  final _imageUrl;
  ViewPhoto(this._imageUrl);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Hero(
              tag: _imageUrl,
              child: Material(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: NetworkImage(this._imageUrl))),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
