import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String message='';
  bool btn_enabled=false;
  var _controller=TextEditingController();

  void sendMessage() async{
    try{
    
     setState(() {
       btn_enabled=false;
     });
     
      final user=await FirebaseAuth.instance.currentUser();
      final userData= await Firestore.instance.collection('users').document(user.uid).get();
      
          
     Firestore.instance.collection('chats/cjAeeG893PhgvVTntvmR/messages').add({
      'text':message.trim(),
      'time':Timestamp.now(),
      'user':user.uid,
      'username':userData['username'],
      'userImage':userData['imageUrl'],
    });
      FocusScope.of(context).unfocus();
       _controller.clear();
      setState(() {
      message='';
    });
    
    

    }catch(err){
      setState(() {
        btn_enabled=true;
      });
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("An error occured")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Row(
        children: <Widget>[
          Expanded(
                    child: TextField(

                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      
                     
              decoration: InputDecoration(hintText: 'Send a new message',),
              onChanged:(val){
                setState(() {
                  btn_enabled= val.trim().isEmpty?false:true;
                  message=val;
                });
              } ,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,color: btn_enabled?Theme.of(context).accentColor:Theme.of(context).disabledColor,),
            onPressed: !btn_enabled?null:sendMessage,
          )

        ],
      ),
    );
  }
}