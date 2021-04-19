import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    // List<String> a,b=queryString.split(",");
    return FirebaseFirestore.instance
        .collection('posts')
        .where('name', isEqualTo: queryString)
        // .where('age', isEqualTo: b)
        .get();
  }
}
