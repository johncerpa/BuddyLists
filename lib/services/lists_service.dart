import 'package:movilfinalapp/models/product.dart';
import 'package:movilfinalapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListsService {
  final dbReference = Firestore.instance;
  final auth = FirebaseAuth.instance;

  // State
  bool isClosed = false;

  // List information
  List<dynamic> lists;
  DocumentReference fbUserList; // Keep track of user list in firebase
  List<SelectedProduct> userList;
  dynamic friendList;

  // History list
  List<dynamic> historyLists;

  ListsService() {
    lists = List<dynamic>();
    historyLists = List<dynamic>();
    userList = List<SelectedProduct>();
  }

  Future postList() async {
    FirebaseUser user = await auth.currentUser();

    try {
      // Check if list is not posted on Firebase, then create it
      if (fbUserList == null) {
        fbUserList = await dbReference.collection('lists').add({
          'finished': false,
          'name': user.displayName,
          'uid': user.uid,
          'products': userList.map((p) => p.toJson()).toList()
        });
      } else {
        // If list is already on Firebase, then update it
        fbUserList.setData({
          'finished': false,
          'name': user.displayName,
          'uid': user.uid,
          'products': userList.map((p) => p.toJson()).toList()
        });
      }
    } catch (error) {
      throw error;
    }
  }

  Future finishLists() async {
    FirebaseUser user = await auth.currentUser();

    fbUserList.setData({
      'finished': true,
      'name': user.displayName,
      'uid': user.uid,
      'products': userList.map((p) => p.toJson()).toList()
    });

    if (friendList != null) {
      DocumentSnapshot res = await dbReference
          .collection('lists')
          .document(friendList['docId'])
          .get();
      await res.reference.updateData(<String, dynamic>{'finished': true});
    }

    // post list to history collection
    final historyList = mergeLists();

    try {
      await dbReference.collection('history').add({
        'name': user.displayName,
        'uid': user.uid,
        'products': historyList.map((p) => p.toJson()).toList()
      });
    } catch (error) {
      print(error);
    }

    // clear selected things
    clearInformation();
  }

  mergeLists() {
    // Merge userList and friendList
    final mergedList = List<HistoryProduct>();

    userList.forEach((p) {
      mergedList.add(HistoryProduct(selectedProduct: p, isOwner: true));
    });

    if (friendList != null) {
      final products = friendList['data']['products'];
      for (var i = 0; i < products.length; i++) {
        final p = products[i];
        final newProduct =
            Product(name: p['productName'], price: p['productPrice']);
        final quantity = p['quantity'];

        // add to merge list
        mergedList.add(HistoryProduct(
            selectedProduct:
                SelectedProduct(product: newProduct, quantity: quantity),
            isOwner: false));
      }
    }

    return mergedList;
  }

  clearInformation() {
    lists.clear();
    userList.clear();
    historyLists.clear();

    fbUserList = null;
    friendList = null;
    // Allow user to change views
    isClosed = false;
  }

  Future getLists() async {
    FirebaseUser user = await auth.currentUser();
    lists.clear();

    try {
      // Get lists that are not finished
      final snapshot = await dbReference
          .collection('lists')
          .where('finished', isEqualTo: false)
          .getDocuments();

      snapshot.documents.forEach((list) {
        // Make sure list doesn't belong to current user
        if (user.uid != list['uid']) {
          lists.add({'data': list.data, 'docId': list.documentID});
        }
      });
    } catch (error) {
      throw error;
    }
  }

  Future getHistoryLists() async {
    final user = await auth.currentUser();
    try {
      final snapshot = await dbReference
          .collection('history')
          .where('uid', isEqualTo: user.uid)
          .getDocuments();

      snapshot.documents.forEach((doc) {
        historyLists.add(doc.data);
      });
    } catch (error) {
      throw error;
    }
  }
}

class HistoryProduct {
  SelectedProduct selectedProduct;
  bool isOwner;
  HistoryProduct({this.selectedProduct, this.isOwner});

  Map<String, dynamic> toJson() => _historyProductToJson(this);

  Map<String, dynamic> _historyProductToJson(HistoryProduct historyProduct) {
    return <String, dynamic>{
      'productName': historyProduct.selectedProduct.product.name,
      'productPrice': historyProduct.selectedProduct.product.price,
      'quantity': historyProduct.selectedProduct.quantity,
      'isOwner': historyProduct.isOwner,
    };
  }
}
