import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/chat/chat_messages.dart';
import 'package:flutter_chat/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fbm=FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure( );
    fbm.subscribeToTopic('chat');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Flutter Chat"),
         actions: <Widget>[
           DropdownButton(
             icon: Icon(Icons.more_vert,color: Theme.of(context).primaryIconTheme.color,),
             onChanged:(value){
               if(value=='logout'){
                 FirebaseAuth.instance.signOut();
               }
             } ,
             items: [
               DropdownMenuItem(
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.exit_to_app),
                     Text("Logout"),
                   ],
                 ),
                 value: 'logout',
               )
             ],
           )
         ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: ChatMessages()),
          NewMessage(),
        ],
      )
      
    );
  }
}