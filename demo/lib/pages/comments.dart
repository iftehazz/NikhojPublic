
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:demo/pages/home.dart';
import 'package:demo/widgets/header.dart';
import 'package:demo/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

final commentsRef = FirebaseFirestore.instance.collection('comments');

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  Comments({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

  @override
  CommentsState createState() => CommentsState(
        postId: this.postId,
        postOwnerId: this.postOwnerId,
        postMediaUrl: this.postMediaUrl,
      );
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentsState({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });
  
  buildComments() {
    print("Comments are being fetched from Firebase");
    return StreamBuilder(
        stream: commentsRef
            .doc(postOwnerId)
            .collection('comments')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Comment> comments = [];
          snapshot.data.documents.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          
          return ListView(
            
            children: comments,
          );
        });
  }


  addComment() {
    commentsRef.doc(postOwnerId).collection("comments").add({
      "username": currentUser.username,
      "comment": commentController.text,
      "timestamp": timestamp,
      "userId": currentUser.id,
    });
    print("Comment is posted");
    commentController.clear();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
                decoration: InputDecoration(labelText: "Write a comment..."),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("Post"),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final TextEditingController commentController = TextEditingController();
  final String username;
  final String userId;
  final String postOwnerId;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.postOwnerId,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: Text(username),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}

