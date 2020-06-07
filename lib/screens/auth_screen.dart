import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/widgets/auth_form.dart';
import 'package:path/path.dart' as path_locator;

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;

  void submitForm(String email, String username, String password,File image, bool isLogin,
      BuildContext ctx) async {
    try {
      setState(() {
        isLoading = true;
      });
      AuthResult authResult;
      if (isLogin)
        authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      else {

        
        authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
         var ref=FirebaseStorage.instance.ref().child('user_images').child(authResult.user.uid + path_locator.extension(image.path));
        await ref.putFile(image).onComplete;
        final url=await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'imageUrl':url.toString(),
        });
      }
    } on PlatformException catch (err) {
      setState(() {
        isLoading = false;
      });
      String msg = "An error occured. Please try again later";
      if (err.message.isNotEmpty) {
        msg = err.message;
      }
      Scaffold.of(ctx).removeCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(msg),
      ));
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitForm, isLoading),
    );
  }
}
