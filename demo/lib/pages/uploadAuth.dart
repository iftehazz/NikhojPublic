import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/pages/newhome.dart';
import 'package:demo/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:demo/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

final postsRef = FirebaseFirestore.instance.collection('posts');
final auth = FirebaseAuth.instance;
final String currentUserId = auth.currentUser.uid;

class UploadAuth extends StatefulWidget {
  final String currentUserId;
  UploadAuth({this.currentUserId});

  @override
  _UploadAuthState createState() => _UploadAuthState();
}

class _UploadAuthState extends State<UploadAuth> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController contactnumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();

  handleTakePhoto() async {
    print("Photo with Camera is picked");
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
      print("Image is picked to Post");
    });
  }

  handleChooseFromGallery() async {
    print("Handle Choose Image from gallery is picked");
    Navigator.pop(context);
    var pickImage = ImagePicker.pickImage(source: ImageSource.gallery);
    File file = await pickImage;
    setState(() {
      this.file = file;
      print("Image is picked to Post");
    });
  }

  selectImage(parentContext) {
    print("Upload Button is pressed");
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"), onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Upload Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                color: Colors.deepOrange,
                onPressed: () => selectImage(context)),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
      print("Image is Compressed to upload");
    });
  }

  Future<String> uploadImage(imageFile) async {
    String url;
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("post_$postId.jpg");
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    uploadTask.whenComplete(() async {
      url = await storageReference.getDownloadURL();
      print(url);
    });
    print("Image is uploaded to Firebase Storage");
    return storageReference.getDownloadURL();
  }

  createPostInFireStore(
      {String mediaUrl,
      String name,
      String age,
      String contact,
      String location}) async {
    DocumentSnapshot doc = await userRef.doc(widget.currentUserId).get();
    Uuser user = Uuser.fromDocument(doc);

    postsRef.doc(currentUserId).set({
      "ownerId": currentUserId,
      "ownerName": user.username,
      "mediaUrl": mediaUrl,
      "postId": postId,
      "name": name,
      "age": age,
      "contact": contact,
      "location": location,
    });
  }

  handleSubmit() async {
    if (contactnumberController.text.isNotEmpty) {
      setState(() {
        isUploading = true;
      });
      await compressImage();
      String mediaUrl = await uploadImage(file);
      createPostInFireStore(
        mediaUrl: mediaUrl,
        name: nameController.text,
        age: ageController.text,
        contact: contactnumberController.text,
        location: locationController.text,
      );

      nameController.clear();
      ageController.clear();
      contactnumberController.clear();
      locationController.clear();
      setState(() {
        print("Information along with picture is uploaded to Firebase");
        file = null;
        isUploading = false;
        postId = Uuid().v4();
      });
    } else {
      print("Contact number field is empty");
      SnackBar snackbar =
          SnackBar(content: Text("Please provide Contact number!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          "Post Information",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            // onPressed: () => isUploading ? null : () => handleSubmit(),
            onPressed: () => handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading:
                // CircleAvatar(
                //   backgroundImage:
                //       CachedNetworkImageProvider(),
                // ),
                Icon(
              Icons.people_alt_sharp,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Write name",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          //

          ListTile(
            leading: Icon(
              Icons.people_alt_sharp,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                  hintText: "Write Age",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          //
          ListTile(
            leading: Icon(
              Icons.contact_phone,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: contactnumberController,
                decoration: InputDecoration(
                  hintText: "Write Contact Number",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          //
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Location",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
