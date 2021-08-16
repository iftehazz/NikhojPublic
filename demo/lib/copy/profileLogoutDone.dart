// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:demo/models/post.dart';
// import 'package:demo/pages/home.dart';
// import 'package:demo/pages/edit_profile.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:demo/widgets/progress.dart';
// import 'package:demo/widgets/post.dart';
// import 'package:demo/models/user.dart';
// import 'package:demo/widgets/header.dart';

// class Profile extends StatefulWidget {
//   final String profileId;

//   Profile({this.profileId});

//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final String currentUserId = currentUser?.id;
//   final postRef = FirebaseFirestore.instance.collection('posts');
//   // Future<DocumentSnapshot> snapshot = await postRef.doc(widget.profileId).get();
//   Post post;
//   bool isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     getProfilePosts();
//   }

//   getProfilePosts() async {
//     setState(() {
//       isLoading = true;
//     });

//     DocumentSnapshot snapshot = await postRef
//         .doc(widget.profileId)
//         // .collection('userPosts')
//         .get();

//     post = Post.fromDocument(snapshot);

//     setState(() {
//       isLoading = false;
//     });
//   }

//   // Column buildCountColumn(String label, int count) {
//   //   return Column(
//   //     mainAxisSize: MainAxisSize.min,
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: <Widget>[
//   //       Text(
//   //         count.toString(),
//   //         style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
//   //       ),
//   //       Container(
//   //         margin: EdgeInsets.only(top: 4.0),
//   //         child: Text(
//   //           label,
//   //           style: TextStyle(
//   //             color: Colors.grey,
//   //             fontSize: 15.0,
//   //             fontWeight: FontWeight.w400,
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   editProfile() {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => EditProfile(currentUserId: currentUserId)));
//   }

//   Container buildButton({String text, Function function}) {
//     return Container(
//       padding: EdgeInsets.only(top: 2.0),
//       child: TextButton(
//         onPressed: function,
//         child: Container(
//           width: 250.0,
//           height: 27.0,
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             border: Border.all(
//               color: Colors.blue,
//             ),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//         ),
//       ),
//     );
//   }

//   buildProfileButton() {
//     // viewing your own profile - should show edit profile button
//     bool isProfileOwner = currentUserId == widget.profileId;
//     if (isProfileOwner) {
//       return buildButton(text: "Edit Post", function: editProfile);
//     }
//   }

//     Container logoutButton({String text, Function function}) {
//     return Container(
//       // padding: EdgeInsets.only(top: 1.0),
//       child: TextButton(
//         onPressed: function,
//         child: Container(
//           width: 220.0,
//           height: 25.0,
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//               fontSize: 17,
//             ),
//           ),
//           alignment: Alignment.center,
//           // decoration: BoxDecoration(
//           //   color: Colors.blue,
//           //   border: Border.all(
//           //     color: Colors.blue,
//           //   ),
//           //   borderRadius: BorderRadius.circular(5.0),
//           // ),
//         ),
//       ),
//     );
//   }


//     buildlogoutButton() {
//     // viewing your own profile - should show edit profile button
//     bool isProfileOwner = currentUserId == widget.profileId;
//     if (isProfileOwner) {
//       return logoutButton(text: "logout", function: logout);
//     }
//   }



//     logout() async {
//     await googleSignIn.signOut();
//     await auth.signOut();
//     Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
//   }

//   buildProfileHeader() {
//     return FutureBuilder(
//       future: userRef.doc(widget.profileId).get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return circularProgress();
//         }
//         Uuser user = Uuser.fromDocument(snapshot.data);
//         return Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   // CircleAvatar(
//                   //   radius: 40.0,
//                   //   backgroundColor: Colors.grey,
//                   //   backgroundImage: CachedNetworkImageProvider(user.photoUrl),
//                   // ),
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           alignment: Alignment.center,
//                           padding: EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             user.username,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.0,
//                             ),
//                           ),
//                         ),
//                         // Row(
//                         //   mainAxisSize: MainAxisSize.max,
//                         //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         //   children: <Widget>[
//                         //     buildCountColumn("posts", 0),
//                         //     buildCountColumn("followers", 0),
//                         //     buildCountColumn("following", 0),
//                         //   ],
//                         // ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             buildProfileButton(),
//                           ],
//                         ),

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             buildlogoutButton(),
//                           ],
                          
//                         ),
//                         //
//                         // Padding(
//                         //   padding: EdgeInsets.all(1.0),
//                         //   child: TextButton.icon(
//                         //     onPressed: logout,
//                         //     icon: Icon(Icons.cancel, color: Colors.red),
//                         //     label: Text(
//                         //       "Logout",
//                         //       style:
//                         //           TextStyle(color: Colors.red, fontSize: 17.0),
//                         //     ),
//                         //   ),
//                         // ),
//                         //
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // Container(
//               //   alignment: Alignment.centerLeft,
//               //   padding: EdgeInsets.only(top: 12.0),
//               //   child: Text(
//               //     user.username,
//               //     style: TextStyle(
//               //       fontWeight: FontWeight.bold,
//               //       fontSize: 16.0,
//               //     ),
//               //   ),
//               // ),
//               // Container(
//               //   alignment: Alignment.centerLeft,
//               //   padding: EdgeInsets.only(top: 4.0),
//               //   child: Text(
//               //     user.displayName,
//               //     style: TextStyle(
//               //       fontWeight: FontWeight.bold,
//               //     ),
//               //   ),
//               // ),
//               // Container(
//               //   alignment: Alignment.centerLeft,
//               //   padding: EdgeInsets.only(top: 2.0),
//               //   child: Text(
//               //     user.bio,
//               //   ),
//               // ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   buildProfilePosts() {
//     if (isLoading) {
//       return circularProgress();
//     }
//     return post;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: header(context, titleText: "Profile"),
//       body: ListView(
//         children: <Widget>[
//           buildProfileHeader(),
//           Divider(
//             height: 0.0,
//           ),
//           buildProfilePosts(),
//         ],
//       ),
//     );
//   }
// }
