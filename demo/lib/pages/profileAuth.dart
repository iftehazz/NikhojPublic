import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/pages/home.dart';
import 'package:demo/pages/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/progress.dart';
import 'package:demo/widgets/postAuth.dart';
import 'package:demo/models/user.dart';
import 'package:demo/widgets/header.dart';

class ProfileAuth extends StatefulWidget {
  final String profileId;

  ProfileAuth({this.profileId});

  @override
  _ProfileAuthState createState() => _ProfileAuthState();
}

class _ProfileAuthState extends State<ProfileAuth> {
  final String currentUserId = auth.currentUser.uid;
  final postRef = FirebaseFirestore.instance.collection('posts');
  PostAuth post;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      print("Post is being fetched from Firebase");
      isLoading = true;
    });
    DocumentSnapshot snapshot = await postRef.doc(widget.profileId).get();
    post = PostAuth.fromDocument(snapshot);
    setState(() {
      print("Post is fetched from Firebase");
      isLoading = false;
    });
  }

  editProfile() {
    print("Edit post is clicked");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUserId)));
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(text: "Edit Post", function: editProfile);
    }
  }

  logout() async {
    print("Logout button is clicked");
    await googleSignIn.signOut();
    await auth.signOut();
    print("logout completed");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: userRef.doc(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Uuser user = Uuser.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            user.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.0),
                          child: TextButton.icon(
                            onPressed: logout,
                            icon: Icon(Icons.cancel, color: Colors.red),
                            label: Text(
                              "Logout",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 17.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    }
    print("Post is fetched");
    return post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          Divider(
            height: 0.0,
          ),
          buildProfilePosts(),
        ],
      ),
    );
  }
}
