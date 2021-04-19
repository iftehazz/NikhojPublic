import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  final String id;
  final String name;
  final String age;
  final String location;

  User({this.id, this.name, this.age, this.location});

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id: doc['id'],
      name: doc['name'],
      age: doc['age'],
      location: doc['location']

    );

  }
}
