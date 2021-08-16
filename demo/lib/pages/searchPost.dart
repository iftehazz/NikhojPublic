import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/widgets/post.dart';
import 'package:demo/widgets/header.dart';
import 'package:demo/widgets/progress.dart';

class SearchPost extends StatefulWidget {
  final String profileId;

  SearchPost({this.profileId});
  @override
  _SearchPostState createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  final postRef = FirebaseFirestore.instance.collection('posts');
  Post post;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot snapshot = await postRef.doc(widget.profileId).get();
    post = Post.fromDocument(snapshot);
    setState(() {
      isLoading = false;
    });
  }

  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    }
    print("Post fetched from database");
    return post;
  }

  back() async {
    Navigator.pop(context);
  }

  buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Container(
          child: TextButton.icon(
            onPressed: back(),
            icon: Icon(Icons.cancel, color: Colors.red),
            label: Text(
              "Back",
              style: TextStyle(color: Colors.red, fontSize: 17.0),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        titleText: "Post",
      ),
      body: ListView(
        padding: EdgeInsets.all(1.0),
        children: <Widget>[
          buildProfilePosts(),
        ],
      ),
    );
  }
}
