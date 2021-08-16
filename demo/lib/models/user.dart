import 'package:cloud_firestore/cloud_firestore.dart';
class Uuser {
  final String id;
  final String username;
  final String email;

  Uuser({this.id, this.username,this.email});

  factory Uuser.fromDocument(DocumentSnapshot doc){
    return Uuser(
      id: doc['id'],
      username: doc['username'],
      email: doc['email'],
    );

  }
}
