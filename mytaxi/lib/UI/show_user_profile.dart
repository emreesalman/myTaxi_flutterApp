import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/raised_button.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'chat.dart';
import 'login.dart';

class UserProfile extends StatefulWidget {

  final MyUser secondUser;

  const UserProfile({Key key, this.secondUser}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final _userModel=Provider.of<UserModel>(context,listen: false);
    MyUser _secondUser=widget.secondUser;
    return Scaffold(
      appBar: AppBar(title: Text(_secondUser.userName.toString())),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            CircleAvatar(
              radius: 60,
              backgroundImage:NetworkImage(_secondUser.profileURL),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _secondUser.name,
                  decoration: InputDecoration(
                    labelText: "Ad",
                    hintText: "Ad",
                    border:OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,width: 5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _secondUser.lastName,
                decoration: InputDecoration(
                  labelText: "Soyad",
                  hintText: "Soyad",
                  border:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _secondUser.userName,
                decoration: InputDecoration(
                  labelText: "Kullanıcı Adı",
                  hintText: "Kullanıcı Adı",
                  border:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                textColor: Colors.black,
                buttonColor: Colors.yellow,
                onPressed: (){
                  Navigator.of(context,rootNavigator: true).push(
                    MaterialPageRoute(builder: (context)=>Chat(currentUser: _userModel.user,secondUser:MyUser.data(
                        userID: _secondUser.userID,userName: _secondUser.userName,profileURL: _secondUser.profileURL)),
                    ),
                  );
                },
                buttonIcon: Icon(Icons.message),
                buttonText: "Mesaj Gönder",
              ),
            ),
          ],
        ),
      ),
    );
  }
}











