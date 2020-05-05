import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/authstate.dart';
import '../services/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/communityScreen.dart';
import '../services/theme_notifier.dart';
import '../utils/theme.dart';

class AddTopic extends StatefulWidget {
  @override
  _AddTopicState createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  var _darkTheme;
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final _auth = Provider.of<AuthenticationState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Start a Topic'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Topic',
                        style: TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 23,
                        ),
                      ),
                      TextFormField(
                        controller: _topicController,
                        validator: Validator.validate,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Category',
                        style: TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 23,
                        ),
                      ),
                      TextFormField(
                        validator: Validator.validate,
                        controller: _categoryController,
                        decoration: InputDecoration(
                            hintText:
                                'Education, Politics, Entertainment, Fashion, etc...'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.78,
                left: MediaQuery.of(context).size.width * 0.72,
                child: FloatingActionButton.extended(
                  splashColor: Colors.green,
                  elevation: 10,
                  label: Text('Start'),
                  backgroundColor: _darkTheme ? Colors.amber : Colors.green,
                  onPressed: () async {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Topic Created'),
                    ));
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      final userId = await Provider.of<AuthenticationState>(
                              context,
                              listen: false)
                          .currentUserId();
                      _auth.addCommunityTopic(
                          userId,
                          Topic(
                              topic: _topicController.text,
                              timestamp: Timestamp.now(),
                              category: _categoryController.text));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommunityScreen()));
                    }
                  },
                ))
          ],
        ));
  }
}

class Validator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Field cannot be empty";
    }
    if (value.length < 2) {
      return "Too short";
    }
    return null;
  }
}
