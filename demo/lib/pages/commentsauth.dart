// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/pages/newhome.dart';
// import 'package:demo/pages/uploadAuth.dart';
import 'package:flutter/material.dart';
// import 'package:demo/pages/home.dart';
import 'package:demo/widgets/header.dart';
import 'package:demo/widgets/progress.dart';
// import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:demo/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

final commentsRef = FirebaseFirestore.instance.collection('comments');
final userRef = FirebaseFirestore.instance.collection('users');
final auth = FirebaseAuth.instance;
final String currentUserId = auth.currentUser.uid;


class CommentsAuth extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentsAuth({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

  @override
  CommentsAuthState createState() => CommentsAuthState(
        postId: this.postId,
        postOwnerId: this.postOwnerId,
        postMediaUrl: this.postMediaUrl,
      );
}

class CommentsAuthState extends State<CommentsAuth> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentsAuthState({
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
          print("Comments are fetched from Firebase");
          return ListView(
            children: comments,
          );
        });
  }

  addComment() async{
      DocumentSnapshot doc =  await userRef.doc(currentUserId).get();
     Uuser user = Uuser.fromDocument(doc);

    commentsRef.doc(postOwnerId).collection("comments").add({
      "username": user.username,
      "comment": commentController.text,
      "timestamp": timestamp,
      "userId": user.id,
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
  // final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.postOwnerId,
    // this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      // avatarUrl: doc['avatarUrl'],
    );
  }

  deleteComment(String userId) async{
     final DocumentSnapshot doc = await commentsRef.doc(postOwnerId).collection("comments").doc(userId).get();
        if (doc.exists) {
      doc.reference.delete();
      
    }
    //  .get();
    // commentsRef.doc(postOwnerId).collection("comments").add({
    //   "username": currentUser.username,
    //   "comment": commentController.text,
    //   "timestamp": timestamp,
    //   // "avatarUrl": currentUser.photoUrl,
    //   "userId": currentUser.id,
    // });
    // commentController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: Text(username),
          // leading: CircleAvatar(
          //   backgroundImage: CachedNetworkImageProvider(avatarUrl),
          // ),
          subtitle: Text(timeago.format(timestamp.toDate())),
          // trailing:  IconButton(
          //   onPressed: () => deleteComment(userId),
          //   icon: Icon(Icons.cancel),
          // ),
        ),
        Divider(),
      ],
    );
  }
}

