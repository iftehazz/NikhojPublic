import 'package:demo/pages/home.dart';
  
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:demo/widgets/header.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body: Center(child: TextButton(child: Text('Logout'),onPressed: (){
        auth.signOut();
        googleSignIn.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      },),),
    );
  }
}