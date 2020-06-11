import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final _firestore = Firestore.instance;
  final auth = FirebaseAuth.instance;
  QuerySnapshot query;
  createChat(String id) async {
    try {
      FirebaseUser user = await auth.currentUser();
      List<String> users = createKey(user.uid.toString(), id);
      String key = users[0] + '_' + users[1];
      var query = await _firestore.collection('chat').document(key).get();

      if (query == null || !query.exists) {
        // Document with id == docId doesn't exist.
        await _firestore
            .collection('chat')
            .document(key)
            .setData({'user': users});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  sendMessage(String mensaje, String id) async {
    try {
      FirebaseUser user = await auth.currentUser();
      List<String> users = createKey(user.uid.toString(), id);
      String key = users[0] + '_' + users[1];
      var now = new DateTime.now();
      var timeS = DateTime.now().millisecondsSinceEpoch;

      await _firestore
          .collection('chat')
          .document(key)
          .collection('chatM')
          .add({
        'enviado': user.uid.toString(),
        'mensaje': mensaje,
        'fecha': now,
        'time': timeS
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot> getMessage(String id) async {
    
    try {
      FirebaseUser user = await auth.currentUser();
      List<String> users = createKey(user.uid.toString(), id);
      String key = users[0] + '_' + users[1];
      var query = await _firestore
          .collection('chat')
          .document(key)
          .collection('chatM')
          .orderBy("time", descending: false)
          .getDocuments();
      this.query = query;
      return query;
    } catch (e) {
      print(e.toString());
    }
  }

  List<String> createKey(String email1, String email2) {
    List<String> users = List<String>();
    users.add(email1);
    users.add(email2);
    users.sort();
    return users;
  }

  bool mine(String id2,String id) {
   
    if (id2 == id) {
      return  true;
    } else {
      return  false;
    }
  }
}
