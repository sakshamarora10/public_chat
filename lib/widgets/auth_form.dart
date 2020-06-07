import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password, File image,
      bool isLogin, BuildContext context) submitCredentials;
  final bool isLoading;
  AuthForm(this.submitCredentials, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String email;
  String username;
  String password;
  File image;

  void submitForm() {
    if(!isLogin && image==null){
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please upload your image"),duration: Duration(seconds: 1),));
      return;
    }
    bool isValidate = formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValidate) {
      formKey.currentState.save();
      widget.submitCredentials(
          email.trim(), 
          !isLogin?username.trim():username, 
          password.trim(), 
          image,
          isLogin, 
          context);
    }
  }

  void getImage() async{
    var pickedImage=await ImagePicker().getImage(source: ImageSource.gallery,imageQuality: 60,maxWidth: 100);
    setState(() {
      image=File(pickedImage.path);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(!isLogin)
                  Column(
                    children: <Widget>[
                      Container(
                        
                        height: 100,
                        width: 100,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(100),
                           color: Colors.grey,
                           image: image==null?null: DecorationImage(image: FileImage(image),fit: BoxFit.cover)
                         ),
                      ),
                      SizedBox(height: 10,),
                      FlatButton.icon(
                        icon: Icon(Icons.image),
                        label: Text("Choose an image"),
                        onPressed: getImage,
                      )
                    ],
                  ),
                  TextFormField(
                    key: ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@'))
                        return 'Enter a valid email';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4)
                          return 'Username must be atleast 4 digits long';
                        else
                          return null;
                      },
                      onSaved: (value) {
                        username = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Password too weak';
                      } else
                        return null;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(isLogin ? "Login" : "Sign up"),
                      onPressed: submitForm,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(isLogin
                          ? "Create a new account"
                          : "Already have an account"),
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
