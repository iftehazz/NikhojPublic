import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:demo/models/post.dart';
// import 'package:fluttershare/pages/activity_feed.dart';
import 'package:demo/pages/searchPost.dart';
import 'package:demo/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  var _params = ['name', 'age', 'contact', 'location'];
  var _currentItemSelected = 'name';

  handleSearch(String query) {
    Future<QuerySnapshot> users = FirebaseFirestore.instance
        .collection('posts')
        .where(_currentItemSelected, isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
    searchResultsFuture = null;
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Enter $_currentItemSelected",
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon:
              DropdownButton<String>(
            items: _params.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            onChanged: (String newValueSelected) {
              setState(() {
                this._currentItemSelected = newValueSelected;
                print("$_currentItemSelected is selected from DropDown menu");
              });
            },
            value: _currentItemSelected,
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  Container buildNoContent() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "Find Missing Person",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          Post user = Post.fromDocument(doc);
          UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);
          print("Search result is fetched from Firebase");
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final Post user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPost(profileId: user.ownerId))),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user.mediaUrl),
              ),
              title: Text(
                user.name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.age,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
