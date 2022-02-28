import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByReference(String searchField) {
    return FirebaseFirestore.instance.collection('soaps').where('reference', arrayContains: searchField).get();
  }
}