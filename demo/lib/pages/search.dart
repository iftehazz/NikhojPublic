// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demo/widgets/progress.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/pages/datacontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;
  @override
  Widget build(BuildContext context) {
    Widget searchedData() {
      return ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
                // backgroundImage: NetworkImage(
                //   snapshotData.docs[index].data()['image']
                // ),
                ),
            title: Text(
              snapshotData.docs[index].data()['name'],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
            subtitle: Text(
              snapshotData.docs[index].data()['age'],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
            
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.clear), onPressed: () {
            setState(() {
              isExecuted=false;
              searchController.clear();
            });
          }),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: AppBar(
        actions: [
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    val.queryData(searchController.text).then((value) {
                      snapshotData = value;
                      setState(() {
                        isExecuted = true;
                      });
                    });
                  });
            },
          )
        ],
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: 'Search missing person',
              hintStyle: TextStyle(color: Colors.white)),
          controller: searchController,
        ),
        backgroundColor: Colors.grey,
      ),
      body: isExecuted
          ? searchedData()
          : Container(
              child: Center(
                  child: Text(
              "Find Missing Person",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 40.0,
              ),
            ))),
    );
  }
}
