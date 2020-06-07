import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movilfinalapp/base/model.dart';
import 'package:movilfinalapp/base/view.dart';
import 'package:movilfinalapp/shared/loading.dart';
import 'package:movilfinalapp/viewmodels/chat_vm.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final user2Id;
  const Chat(this.user2Id);
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ChatViewModel model = ChatViewModel();
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: ChangeNotifierProvider<ChatViewModel>(
            create: (Context) => ChatViewModel(),
            child: Consumer<ChatViewModel>(builder: (context, model, children) {
              return chat(model);
            })));
  }

  Widget chat(ChatViewModel model) {
    return Stack(
      children: <Widget>[
        mess(context, model),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.grey,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: "Mensaje",
                            border: InputBorder.none))),
                MaterialButton(
                    child: Text(
                      "Enviar ",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () async {
                      if (messageController.text != null ||
                          messageController.text == '') {
                        model.sendMessage(
                            widget.user2Id, messageController.text);
                        messageController.text = '';
                      }
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget mess(BuildContext context, ChatViewModel model) {
    return FutureBuilder(
      future: model.getMessage(widget.user2Id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.toList().length > 0) {
            return mList(context, snapshot.data,model);
          }else{ return Text("Escribe un mensaje");}
        } else {
          return Loading();
        }
      },
    );
  }

  Widget mList(
    BuildContext context,
    QuerySnapshot snapshot,ChatViewModel model
  ) {
    return ListView.builder(
      itemCount: snapshot.documents.length,
      itemBuilder: (context, position) {
        bool mio =model.mine(snapshot.documents[position].data['enviado']);
        return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.only(left: mio ? 0 : 24, right: mio ? 24 : 0),
            width: MediaQuery.of(context).size.width,
            alignment: mio ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: mio
                          ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                          : [Colors.black, Colors.black]),
                  borderRadius: mio
                      ? BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.circular(23))
                      : BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomRight: Radius.circular(23))),
              child: Text(
                snapshot.documents[position].data['mensaje'],
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ));
      },
    );
  }

  
}
