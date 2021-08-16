import 'dart:async';

import 'package:demo/pages/createUname.dart';
// import 'package:demo/pages/feed.dart';
import 'package:demo/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demo/pages/create_account.dart';
// import 'package:uuid/uuid.dart';

import 'package:demo/models/user.dart';
Uuser currentUser;

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  // String userid = Uuid().v4();
  final userRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('An email has been sent to ${user.email} please verify'),
      ),
    );
  }

  createUserInFirestore() async {
    user = auth.currentUser;
    userRef.doc(user.uid).set({
      "id": user.uid,
      "email": user.email,
      "timestamp": timestamp,
    });
    DocumentSnapshot doc = await userRef.doc(user.uid).get();
    currentUser = Uuser.fromDocument(doc);
    // // currentUser = auth.currentUser;
    print("User is created in firestore");
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      print("User is verified");
      // final username = await Navigator.push(context, MaterialPageRoute(builder: (context)=>
      // CreateAccount()));
      // createUserInFirestore(username);
      createUserInFirestore();
      timer.cancel();
      
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => CreateUsername()));
    }
  }
}
