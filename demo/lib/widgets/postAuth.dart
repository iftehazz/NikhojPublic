// import 'package:demo/pages/newhome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demo/models/post.dart';
import 'package:demo/widgets/progress.dart';
import 'package:demo/models/user.dart';
import 'package:demo/pages/commentsauth.dart';

final postRef = FirebaseFirestore.instance.collection('posts');
// final DateTime timestamp = DateTime.now();

Uuser uuser;

class PostAuth extends StatefulWidget {
  final String ownerId;
  final String ownerName;
  // final String timestamp;
  final String postId;
  final String name;
  final String mediaUrl;
  final String age;
  final String contact;
  final String location;
  PostAuth(
      {this.ownerId,
      this.ownerName,
      // this.timestamp,
      this.postId,
      this.name,
      this.mediaUrl,
      this.age,
      this.contact,
      this.location});

  factory PostAuth.fromDocument(DocumentSnapshot doc) {
    return PostAuth(
        ownerId: doc['ownerId'],
        ownerName: doc['ownerName'],
        // timestamp: doc['timestamp'],
        postId: doc['postId'],
        mediaUrl: doc['mediaUrl'],
        name: doc['name'],
        age: doc['age'],
        contact: doc['contact'],
        location: doc['location']);
  }

  @override
  _PostAuthState createState() => _PostAuthState(
      postId: this.postId,
      ownerId: this.ownerId,
      ownerName: this.ownerName,
      // timestamp: this.timestamp,
      name: this.name,
      mediaUrl: this.mediaUrl,
      age: this.age,
      contact: this.contact,
      location: this.location);
}

class _PostAuthState extends State<PostAuth> {
  final String ownerId;
  final String ownerName;
  // final String timestamp;
  final String postId;
  final String name;
  final String mediaUrl;
  final String age;
  final String contact;
  final String location;
  _PostAuthState(
      {this.ownerId,
      this.ownerName,
      // this.timestamp,
      this.postId,
      this.name,
      this.mediaUrl,
      this.age,
      this.contact,
      this.location});

  // deletePost() async{
  //   final DocumentSnapshot doc = await postRef.doc(ownerId).get();
  //   if(doc.exists){
  //     doc.reference.delete();
  //   }
  // }


  //   deletePost() {
  //  postRef.doc(ownerId).delete();

  // }

  buildPostHeader() {
    return FutureBuilder(
      future: postRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        // Post post = Post.fromDocument(snapshot.data);

        // Uuser user = Uuser.fromDocument(snapshot.data);
        // String uname= user.username;
        return ListTile(
          // leading: CircleAvatar(
          //   backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          //   backgroundColor: Colors.grey,
          // ),
          title: GestureDetector(
            onTap: () => print('showing profile'),
            child: Text(
              // "Name: $name",
              // post.name,
              "$ownerName",

              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //  subtitle: Text("timestamp"),
          // trailing: IconButton(
          //   onPressed: () => print("Delete post"),
          //   icon: Icon(Icons.more_vert),
          // ),
        );
      },
    );
  }

  buildPostImage() {
    return GestureDetector(
      // onDoubleTap: () => print('liking post'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(mediaUrl),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        // Row(
        //   children: <Widget>[
        //     Container(
        //       margin: EdgeInsets.only(left: 20.0),
        //       child: Text(
        //         "$likeCount likes",
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "Name: " "$name ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Expanded(child: Text(description))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "Age: " "$age ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Expanded(child: Text(description))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "Contact: " "$contact ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Expanded(child: Text(description))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "Location: " "$location ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Expanded(child: Text(description))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            // GestureDetector(
            //   onTap: () => print('liking post'),
            //   child: Icon(
            //     Icons.favorite_border,
            //     size: 28.0,
            //     color: Colors.pink,
            //   ),
            // ),
            Padding(padding: EdgeInsets.all(20.0)),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: postId,
                ownerId: ownerId,
                mediaUrl: mediaUrl,
              ),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter()
      ],
    );
  }
}

showComments(BuildContext context,
    {String postId, String ownerId, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CommentsAuth(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));
}
