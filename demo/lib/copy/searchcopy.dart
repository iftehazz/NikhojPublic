// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demo/widgets/progress.dart';
// import 'package:flutter/material.dart';
// import 'feed.dart';
// // import 'package:demo/models/user.dart';

// class Search extends StatefulWidget {
//   @override
//   _SearchState createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   TextEditingController searchController = TextEditingController();

//   clearSearch() {
//     searchController.clear();
//   }

//   Future<QuerySnapshot> searchResultsFuture;
//   Future<QuerySnapshot> doc;

//   handleSearch(String query) {
//     //String a,b,c= query.split(",") as String;
//     Future<QuerySnapshot> users =
//         userRef.where('name', isEqualTo: query).get();

//     setState(() {
//       searchResultsFuture = users;
//       doc=users;
//     });
//   }

//   AppBar buildSearchField() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       title: TextFormField(
//         controller: searchController,
//         decoration: InputDecoration(
//           hintText: "Search for a missing person",
//           filled: true,
//           prefixIcon: Icon(
//             Icons.account_box,
//             size: 28.0,
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(Icons.clear),
//             onPressed: () => clearSearch(),
//           ),
//         ),
//         onFieldSubmitted: handleSearch,
//       ),
//     );
//   }

//   Container buildNoContent() {
//     MediaQuery.of(context).orientation;
//     return Container(
//       child: Center(
//         child: ListView(
//           shrinkWrap: true,
//           children: <Widget>[
//             // SvgPicture.asset(
//             //   'assests/images/search.svg',
//             //   height: 300,
//             // ),
//             Text(
//               "Find Missing Person",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 40.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   buildSearchResults() {
//     return FutureBuilder<QuerySnapshot>(
//         future: searchResultsFuture,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return circularProgress();
//           }
//           List<Text> searchResult = [];
//           // snapshot.data.docs.forEach((doc) {
            
//           //   User user = User.fromDocument(doc);
//           //   searchResult.add(Text(user.name));
//           // });
//           return ListView(
//             children: searchResult,
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
//       appBar: buildSearchField(),
//       body:
//           searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
//     );
//   }
// }

// class UserResult extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Text("User Result");
//   }
// }
