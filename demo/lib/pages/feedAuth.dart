import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:demo/models/user.dart';
// import 'package:demo/pages/newhome.dart';
import 'package:demo/widgets/header.dart';
import 'package:demo/widgets/postAuth.dart';
import 'package:demo/widgets/progress.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final postRef = FirebaseFirestore.instance.collection('posts');

class FeedAuth extends StatefulWidget {
  // final Uuser currentUser;
  final String currentUserId;

  FeedAuth({this.currentUserId});

  @override
  _FeedAuthState createState() => _FeedAuthState();
}

class _FeedAuthState extends State<FeedAuth> {
  List<PostAuth> posts;

  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    print("Post is being showed in Timeline");
    QuerySnapshot snapshot = await postRef.get();
    List<PostAuth> posts =
        snapshot.docs.map((doc) => PostAuth.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Text("No posts");
    } else {
      print("Post is being fetched in Timeline");
      return ListView(children: posts);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline()));
  }
}
