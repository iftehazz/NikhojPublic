import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/post.dart';
import 'package:demo/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';

final postRef = FirebaseFirestore.instance.collection('posts');
final CollectionReference commentsRef =
    FirebaseFirestore.instance.collection('comments');
var isDeleted = false;

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController contactnumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isLoading = false;
  bool isDeleted = false;
  Post post;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      print("Post is being fetched from Firebase");
      isLoading = true;
    });
    DocumentSnapshot doc = await postRef.doc(widget.currentUserId).get();
    post = Post.fromDocument(doc);

    nameController.text = post.name;
    ageController.text = post.age;
    contactnumberController.text = post.contact;
    locationController.text = post.location;

    setState(() {
      print("Post is fetched from Firebase");
      isLoading = false;
    });
  }

  Column buildnameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "Update Name",
          ),
        )
      ],
    );
  }

  Column buildageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Age",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: ageController,
          decoration: InputDecoration(
            hintText: "Update Age",
          ),
        )
      ],
    );
  }

  Column buildcontactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Contact Number",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: contactnumberController,
          decoration: InputDecoration(
            hintText: "Update Contact Number",
          ),
        )
      ],
    );
  }

  Column buildlocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Location",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: locationController,
          decoration: InputDecoration(
            hintText: "Update Location",
          ),
        )
      ],
    );
  }

  updatePostInFireStore(
      {String name, String age, String contact, String location}) {
    postRef.doc(widget.currentUserId).update({
      "name": name,
      "age": age,
      "contact": contact,
      "location": location,
    });
    print("Post is Updated to Firebase");
    SnackBar snackbar = SnackBar(content: Text("Post updated!"));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  updateProfileData() {
    updatePostInFireStore(
        name: nameController.text,
        age: ageController.text,
        contact: contactnumberController.text,
        location: locationController.text);
  }

  deletePost() async {
    final DocumentSnapshot doc = await postRef.doc(widget.currentUserId).get();
    if (doc.exists) {
      print("Post is deleted from Firebase");
      doc.reference.delete();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Post",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              CachedNetworkImageProvider(post.mediaUrl),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildnameField(),
                            buildageField(),
                            buildcontactField(),
                            buildlocationField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: updateProfileData,
                        child: Text(
                          "Update Post",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextButton.icon(
                          onPressed: deletePost,
                          icon: Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            "Delete Post",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
