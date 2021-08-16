// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demo/widgets/progress.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as Im;
// import 'package:uuid/uuid.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// final postsRef = FirebaseFirestore.instance.collection('posts');

// class Upload extends StatefulWidget {
//   @override
//   _UploadState createState() => _UploadState();
// }

// class _UploadState extends State<Upload> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController contactnumberController = TextEditingController();
//   TextEditingController locationController = TextEditingController();

//   File file;
//   bool isUploading = false;
//   String postId = Uuid().v4();

//   handleTakePhoto() async {
//     Navigator.pop(context);
//     File file = await ImagePicker.pickImage(
//       source: ImageSource.camera,
//       maxHeight: 675,
//       maxWidth: 960,
//     );
//     setState(() {
//       this.file = file;
//     });
//   }

//   handleChooseFromGallery() async {
//     Navigator.pop(context);
//     var pickImage = ImagePicker.pickImage(source: ImageSource.gallery);
//     File file = await pickImage;
//     setState(() {
//       this.file = file;
//     });
//   }

//   selectImage(parentContext) {
//     return showDialog(
//       context: parentContext,
//       builder: (context) {
//         return SimpleDialog(
//           title: Text("Create Post"),
//           children: <Widget>[
//             SimpleDialogOption(
//                 child: Text("Photo with Camera"), onPressed: handleTakePhoto),
//             SimpleDialogOption(
//                 child: Text("Image from Gallery"),
//                 onPressed: handleChooseFromGallery),
//             SimpleDialogOption(
//               child: Text("Cancel"),
//               onPressed: () => Navigator.pop(context),
//             )
//           ],
//         );
//       },
//     );
//   }

//   Container buildSplashScreen() {
//     return Container(
//       color: Theme.of(context).accentColor.withOpacity(0.6),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           // SvgPicture.asset('assets/images/upload.svg', height: 260.0),
//           Padding(
//             padding: EdgeInsets.only(top: 20.0),
//             child: RaisedButton(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Text(
//                   "Upload Image",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22.0,
//                   ),
//                 ),
//                 color: Colors.deepOrange,
//                 onPressed: () => selectImage(context)),
//           ),
//         ],
//       ),
//     );
//   }

//   clearImage() {
//     setState(() {
//       file = null;
//     });
//   }

//   compressImage() async {
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;
//     Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
//     final compressedImageFile = File('$path/img_$postId.jpg')
//       ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
//     setState(() {
//       file = compressedImageFile;
//     });
//   }

//   String url;

//   uploadImage(imageFile) async {
//     final Reference storageReference =
//         FirebaseStorage.instance.ref().child("post_$postId.jpg");
//     final UploadTask uploadTask = storageReference.putFile(imageFile);
//     uploadTask.then((TaskSnapshot taskSnapshot) async {
//       url = await taskSnapshot.ref.getDownloadURL();
//     }).catchError((onError) {
//       print(onError);
//     });
//     return url;
//   }

//   createPostInFireStore(
//       {String mediaUrl,
//       String name,
//       String age,
//       String contact,
//       String location}) {
//     postsRef.doc(postId).set({
//       "postId": postId,
//       "mediaUrl": mediaUrl,
//       "name": name,
//       "age": age,
//       "contact": contact,
//       "location": location,
//     });
//   }

//   handleSubmit() async {
//     setState(() {
//       isUploading = true;
//     });
//     await compressImage();
//     String mediaUrl = await uploadImage(file);
//     createPostInFireStore(
//       mediaUrl: mediaUrl,
//       name: nameController.text,
//       age: ageController.text,
//       contact: contactnumberController.text,
//       location: locationController.text,
//     );

//     nameController.clear();
//     ageController.clear();
//     contactnumberController.clear();
//     locationController.clear();
//     setState(() {
//       file = null;
//       isUploading = false;
//       postId = Uuid().v4();
//     });
//   }

//   Scaffold buildUploadForm() {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white70,
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: clearImage),
//         title: Text(
//           "Post Information",
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           FlatButton(
//             onPressed: () => isUploading ? null : () => handleSubmit(),
//             child: Text(
//               "Post",
//               style: TextStyle(
//                 color: Colors.blueAccent,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: ListView(
//         children: <Widget>[
//           isUploading ? linearProgress() : Text(""),
//           Container(
//             height: 220.0,
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: FileImage(file),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 10.0),
//           ),
//           ListTile(
//             leading:
//                 // CircleAvatar(
//                 //   backgroundImage:
//                 //       CachedNetworkImageProvider(),
//                 // ),
//                 Icon(
//               Icons.people_alt_sharp,
//               color: Colors.orange,
//               size: 35.0,
//             ),
//             title: Container(
//               width: 250.0,
//               child: TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   hintText: "Write name",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           Divider(),
//           //

//           ListTile(
//             leading: Icon(
//               Icons.people_alt_sharp,
//               color: Colors.orange,
//               size: 35.0,
//             ),
//             title: Container(
//               width: 250.0,
//               child: TextField(
//                 controller: ageController,
//                 decoration: InputDecoration(
//                   hintText: "Write Age",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           Divider(),
//           //
//           ListTile(
//             leading: Icon(
//               Icons.contact_phone,
//               color: Colors.orange,
//               size: 35.0,
//             ),
//             title: Container(
//               width: 250.0,
//               child: TextField(
//                 controller: contactnumberController,
//                 decoration: InputDecoration(
//                   hintText: "Write Contact Number",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           Divider(),
//           //
//           ListTile(
//             leading: Icon(
//               Icons.pin_drop,
//               color: Colors.orange,
//               size: 35.0,
//             ),
//             title: Container(
//               width: 250.0,
//               child: TextField(
//                 controller: locationController,
//                 decoration: InputDecoration(
//                   hintText: "Location",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return file == null ? buildSplashScreen() : buildUploadForm();
//   }
// }
