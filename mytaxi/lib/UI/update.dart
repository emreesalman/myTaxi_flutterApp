

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore=FirebaseFirestore.instance;
class updateView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdateState();
  }
}
class UpdateState extends State<updateView>{
  String _ad,_soyad,_email,_password,_telefon;
  bool validateControl=false;
  final FormUpdateKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Giris Yap"),),
      body: Padding(padding: EdgeInsets.all(20),
        child: Form(
          key: FormUpdateKey,
          autovalidate: validateControl,

          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  hintText: "Adiniz",
                  labelText: "Ad",
                  border: OutlineInputBorder(),
                ),
                validator: _isimKontrol,
                onSaved: (deger)=>_ad=deger,
              ),
              SizedBox(height:10),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  hintText: "Soyadiniz",
                  labelText: "Soyad",
                  border: OutlineInputBorder(),
                ),
                validator: _isimKontrol,
                onSaved: (deger)=>_soyad=deger,
              ),
              SizedBox(height:10),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: "Telefon Numaraniz",
                  labelText: "Telefon Numarasi",
                  border: OutlineInputBorder(),
                ),
                validator:_telNoKontrol,
                onSaved:(deger)=>_telefon=deger,
              ),
              SizedBox(height:10),
              SizedBox(height:10),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Sifreniz",
                  labelText: "Sifre",
                  border: OutlineInputBorder(),
                ),
                validator: _passwordKontrol,
                onSaved: (deger)=>_password=deger,
              ),
              RaisedButton(
                child: Text("Kayit Ol"),
                onPressed: _signUp,
              ),
            ],
          ),
        ),),
    );
  }
  void _signUp(){
    if(FormUpdateKey.currentState.validate()){
      FormUpdateKey.currentState.save();
      Map<String,dynamic> updateUser=Map();
      String newUserID= _firestore.collection("users").doc().id;
      String userID=
      updateUser['id']=newUserID;
      updateUser['ad']=_ad;
      updateUser['soyad']=_soyad;
      updateUser['tel_no']=_telefon;
      updateUser['password']=_password;

      _firestore.collection("users").doc(newUserID).update(updateUser).whenComplete(()=>debugPrint("guncellendi"));
    }else{
      setState(() {
        validateControl=true;
      });
    }
  }

  String _emailKontrol(String mail){
    //Pattern pattern=
    // "r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))";
    // RegExp regexp = new RegExp(pattern);
    // if(regexp.hasMatch(mail)){
    // return "Mail Gecersiz";
    //}else return null;
    return null;
  }
  String _isimKontrol(String veri){
    return null;
    //Turkce karakterleri algilayan regexp bul
  }
  String _passwordKontrol(String sifre){
    if(sifre.length <6){
      return "Daha uzun olmali";
    }else return null;
  }
  String _telNoKontrol(String tel) {
    return null;
  }

}


