import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/services/auth.dart';
import 'package:movilfinalapp/services/auth_provider.dart';
import 'package:movilfinalapp/services/chat.dart';
import 'package:provider/provider.dart';

import '../locator.dart';

class ChatViewModel extends BaseModel {
  final chat = locator<ChatService>();
  final authService=locator<AuthProvider>();
  QuerySnapshot messages;
  Future createChat(String id) async {
    await chat.createChat(id);
    notifyListeners();
  }

  Future sendMessage(String id, String mensaje) async {
    await chat.sendMessage(mensaje, id);
    notifyListeners();
  }
  bool mine(String id2){
 
 
  
    return chat.mine(id2, authService.uid);

  }
  Future<QuerySnapshot> getMessage(String id) async {
    
    var query=await chat.getMessage(id);
    
    notifyListeners();
    return query;
 
  }
}
