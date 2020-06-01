import 'package:movilfinalapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductService {
  final dbReference = Firestore.instance;
  final auth = FirebaseAuth.instance;

  Future postList(List<SelectedProduct> selectedProducts) async {
    FirebaseUser user = await auth.currentUser();
    final ref = await dbReference.collection('lists').add({
      'nombre': user.displayName,
      'uid': user.uid,
      'products': selectedProducts.map((p) => p.toJson()).toList()
    });

    print(ref.documentID);
  }
}
