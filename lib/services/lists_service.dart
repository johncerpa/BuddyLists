import 'package:movilfinalapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListsService {
  final dbReference = Firestore.instance;
  final auth = FirebaseAuth.instance;

  DocumentReference cloudList;
  List<SelectedProduct> userList;
  List<dynamic> lists;

  ListsService() {
    lists = List<dynamic>();
    userList = List<SelectedProduct>();
  }

  Future postList() async {
    FirebaseUser user = await auth.currentUser();

    try {
      // Check if list is not posted on Firebase, then create it
      if (cloudList == null) {
        cloudList = await dbReference.collection('lists').add({
          'name': user.displayName,
          'uid': user.uid,
          'products': userList.map((p) => p.toJson()).toList()
        });
      } else {
        // If list is already on Firebase, then update it
        cloudList.setData({
          'name': user.displayName,
          'uid': user.uid,
          'products': userList.map((p) => p.toJson()).toList()
        });
      }
    } catch (error) {
      throw error;
    }
  }

  Future getLists() async {
    FirebaseUser user = await auth.currentUser();
    lists.clear();

    try {
      final snapshot = await dbReference.collection('lists').getDocuments();
      snapshot.documents.forEach((list) {
        // Make sure list doesn't belong to current user
        if (user.uid == list['uid']) {
          lists.add(list.data);
        }
      });
    } catch (error) {
      throw error;
    }
  }
}
