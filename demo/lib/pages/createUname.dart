import 'package:demo/models/user.dart';
// import 'package:demo/pages/home.dart';
import 'package:demo/pages/newhome.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUsername extends StatefulWidget {
  @override
  _CreateUsernameState createState() => _CreateUsernameState();
}

class _CreateUsernameState extends State<CreateUsername> {
  String _uname;
  final user = FirebaseAuth.instance.currentUser;
  final userRef = FirebaseFirestore.instance.collection('users');
  final DateTime timestamp = DateTime.now();
  Uuser currentUser;
  
  updateUser(String _uname) async {
    final doc = await userRef.doc(user.uid).get();
    if (doc.exists) {
      doc.reference.update({
        "id": user.uid,
        "username": _uname,
        "email": user.email,
        "timestamp": timestamp,
      });
      currentUser = Uuser.fromDocument(doc);
      print("Username is created in firestore");
    }
  }

  // submit(String _uname) {
  //   updateUser(_uname);
  // }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context, titleText: "Set up your profile"),
      body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: false,
                decoration: InputDecoration(
                    hintText: 'Must be at least 6 character',
                    border: OutlineInputBorder(),
                    labelText: "username",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                autovalidate: true,
                validator: (value) {
                  if (value.trim().length < 6 || value.isEmpty) {
                    print(
                        "Error: Username length is below 6 character or empty");
                    return "username has to be at least 6 character";
                  } else {
                    print("Username is good to go");
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _uname = value.trim();
                  });
                },
              ),
            ),
          ),

          //
          Container(
            height: 50,
            width: 50,
            child: RaisedButton(
              
                color: Theme.of(context).accentColor,
                child: Text('Submit'),
                padding: EdgeInsets.all(7.0),
                onPressed: () {
                  updateUser(_uname).then((_) {
                    Navigator.of(context)
                        .pushReplacement(
                            MaterialPageRoute(builder: (context) => NewHome()))
                        .catchError((e) {
                      print(e);
                      print("error occured");
                    });
                  });
                  print("Submit is done");
                  print("Headed to Newsfeed");
                }),
          )
        ],
      ),
    );
  }
}
