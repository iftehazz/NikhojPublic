import 'package:cloud_firestore/cloud_firestore.dart';
class Comment {
  final String userId;
  final String username;
  final String comment;

  Comment({this.userId, this.username,this.comment});

  factory Comment.fromDocument(DocumentSnapshot doc){
    return Comment(
      userId: doc['userId'],
      username: doc['username'],
      comment: doc['comment'],
    );

  }
}
