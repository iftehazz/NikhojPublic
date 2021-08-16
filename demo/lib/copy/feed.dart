// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:demo/pages/home.dart';
// import 'package:demo/widgets/header.dart';
// import 'package:demo/widgets/progress.dart';
// //import 'package:firebase_auth/firebase_auth.dart';
// //import 'package:demo/widgets/progress.dart';
// import 'package:flutter/material.dart';
// // import 'package:demo/models/user.dart';


// final userRef = FirebaseFirestore.instance.collection('posts'); //Firebase-bad
// // User currentUser;

// class Feed extends StatefulWidget {
//   @override
//   _FeedState createState() => _FeedState();
// }

// class _FeedState extends State<Feed> {
//   List<dynamic> users = [];
//   @override
//   void initState() {
//     // getUsers();
//     // createUser();
//     //updateUser();
//     //deleteUser();
//     super.initState();
//   }

//   createUser() {
//     userRef
//         .doc("asdfasfd")
//         .set({"name": "Reaz","contact": "01817232445", "age": "14", "location": "Khulna"});
//       // currentUser = User.fromDocument();
//   }

//   updateUser() async {
//     final doc = await userRef.doc("asdfasfd").get();
//     // update({"username": "Abir","postCount": 0,"isAdmin":false});
//     if (doc.exists) {
//       doc.reference
//           .update({"name": "Samin","contact": "01817232445", "age": "14", "location": "Khulna"});
//     }
//   }

//   deleteUser() async {
//     final DocumentSnapshot doc = await userRef.doc("asdfasfd").get();
//     if (doc.exists) {
//       doc.reference.delete();
//     }
//   }

//   // getUsers(){
//   //   userRef.get().then((QuerySnapshot snapshot){ //.getDocuments
//   //     snapshot.docs.forEach((DocumentSnapshot doc) { //.documents
//   //       print(doc["username"]);
//   //       print(doc.exists);
//   //       print(doc.id);
//   //     });
//   //   });
//   // } this is wrong

// // getUserById() async{
// //   final String id= "IwWpur9Ok6JoxoDllvvn";
// //   final DocumentSnapshot doc = await userRef.doc(id).get();
// //          print(doc["username"]);
// //             print(doc["isAdmin"]);
// //               print(doc["postCount"]);
// //          print(doc.exists);

// // } this is okay

// // /////////////////////////////////////////////////////////for multiple query create index at Firestore
// // getUsers() async{
// //   final QuerySnapshot snapshot = await userRef
// //   .where("postCount", isLessThan: 5)
// //   .where("username", isEqualTo: "Ifti").get();
// //   snapshot.docs.forEach((DocumentSnapshot doc) {
// //     print(doc["username"]);
// //    });
// // }
// ///////////////////////////////////////////////////////////////////////////////////

// // getUsers() async{
// //   final QuerySnapshot snapshot = await userRef.get();
// //   // .where("postCount", isLessThan: 5)
// //   // .where("username", isEqualTo: "Ifti").get();
// //   setState(() {
// //     users =  snapshot.docs;
// //   });
// // }

//   @override
//   Widget build(context) {
//     return Scaffold(
//       appBar: header(context, isAppTitle: true),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: userRef.snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return circularProgress();
//           }
//           final List<Text> children =
//               snapshot.data.docs.map((doc) => Text(doc['name'])).toList();
//           return Container(
//             child: ListView(
//               children: children,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
