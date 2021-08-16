import 'package:cloud_firestore/cloud_firestore.dart';
class Post {
  final String ownerId;
  final String ownerName;
  // final String timestamp;
  final String name;
  final String mediaUrl;
  final String age;
  final String contact;
  final String location;
  

  Post({this.ownerId,this.ownerName,
  // this.timestamp, 
  this.name, this.mediaUrl,this.age,this.contact,this.location});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      ownerId: doc['ownerId'],
      ownerName: doc['ownerName'],
      // timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
      name: doc['name'],
      age:doc['age'],
      contact: doc['contact'],
      location: doc['location'],
      
    );
  }
}
