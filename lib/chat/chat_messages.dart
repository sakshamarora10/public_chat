

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chat/chat_bubble.dart';

class ChatMessages extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx,userSnapshot){
        if(userSnapshot.connectionState==ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else{
          return StreamBuilder(
            stream: Firestore.instance.collection('chats/cjAeeG893PhgvVTntvmR/messages/').orderBy('time',descending: true).snapshots(),
            builder: (ctx,chatSnapshot){
              if(chatSnapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              else{

               
                return ListView.builder(
                  reverse: true,
                  itemCount: chatSnapshot.data.documents.length,
                  itemBuilder: (context, index) => ChatBubble(
                    index,
                    chatSnapshot.data.documents[index]['text'],
                    chatSnapshot.data.documents[index]['user']==userSnapshot.data.uid,
                    chatSnapshot.data.documents[index]['username'],
                    chatSnapshot.data.documents[index]['userImage'],
                    key: ValueKey(chatSnapshot.data.documents[index].documentID), ),
                );
              }
            },
          );
        }
      },
    );
  }
}