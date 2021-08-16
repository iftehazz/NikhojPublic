
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo/widgets/progress.dart';
import 'package:demo/models/user.dart';
import 'package:demo/pages/comments.dart';

final postRef = FirebaseFirestore.instance.collection('posts');

Uuser uuser;

class Post extends StatefulWidget {
  final String ownerId;
  final String ownerName;
  final String postId;
  final String name;
  final String mediaUrl;
  final String age;
  final String contact;
  final String location;
  Post(
      {this.ownerId,
      this.ownerName,
      this.postId,
      this.name,
      this.mediaUrl,
      this.age,
      this.contact,
      this.location});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
        ownerId: doc['ownerId'],
        ownerName: doc['ownerName'],
        // timestamp: doc['timestamp'],
        postId: doc['postId'],
        mediaUrl: doc['mediaUrl'],
        name: doc['name'],
        age: doc['age'],
        contact: doc['contact'],
        location: doc['location']);
  }

  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      ownerId: this.ownerId,
      ownerName: this.ownerName,
      name: this.name,
      mediaUrl: this.mediaUrl,
      age: this.age,
      contact: this.contact,
      location: this.location);
}

class _PostState extends State<Post> {
  final String ownerId;
  final String ownerName;
  final String postId;
  final String name;
  final String mediaUrl;
  final String age;
  final String contact;
  final String location;
  _PostState(
      {this.ownerId,
      this.ownerName,
      this.postId,
      this.name,
      this.mediaUrl,
      this.age,
      this.contact,
      this.location});



  buildPostHeader() {
    return FutureBuilder(
      future: postRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        return ListTile(

          title: GestureDetector(
            onTap: () => print('showing profile'),
            child: Text(
              "$ownerName",

              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  buildPostImage() {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(mediaUrl),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "Name: " "$name ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "Age: " "$age ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "Contact: " "$contact ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "Location: " "$location ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20.0)),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: postId,
                ownerId: ownerId,
                mediaUrl: mediaUrl,
              ),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter()
      ],
    );
  }
}

showComments(BuildContext context,
    {String postId, String ownerId, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));
}
