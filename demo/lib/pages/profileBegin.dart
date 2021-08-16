// import 'package:demo/pages/home.dart';
  
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:demo/widgets/header.dart';
// import 'package:flutter/material.dart';

// class ProfileBegin extends StatefulWidget {
//   @override
//   _ProfileBeginState createState() => _ProfileBeginState();
// }

// class _ProfileBeginState extends State<ProfileBegin> {
//   final auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(  
//       body: Center(child: TextButton(child: Text('Logout'),onPressed: (){
//         auth.signOut();
//         googleSignIn.signOut();
//         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
//       },),),
//     );
//   }
// }