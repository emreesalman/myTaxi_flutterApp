import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/errors.dart';
import 'package:mytaxi/app/raised_button.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignUpView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpState();
  }
}
class SignUpState extends State<SignUpView>{
  String _ad,_soyad,_email,_password,_telefon;


  final _formSignUpKey=GlobalKey<FormState>();
  _formSubmit(BuildContext context) async{
    _formSignUpKey.currentState.save();
    final _userModel=Provider.of<UserModel>(context,listen: false);
   try{
     MyUser _olusturulanUser= await _userModel.createUserWithEmailAndPassword(_email, _password,_ad,_soyad,_telefon);
     if(_olusturulanUser!=null){
       Navigator.of(context).pop();
       _showDialog(context);
      await _userModel.signOut();
     }
   }on FirebaseAuthException catch(e){
     print("user olusturulurken hata: "+e.code.toString());
     return AlertDialogWidget(
       baslik: 'Kayit Olusturulurken Hata',
       icerik: e.message.toString(),
       buttonText: 'Tamam',
     ).show(context);
   }
  }
  @override
  Widget build(BuildContext context) {
    final _userModel=Provider.of<UserModel>(context,listen: false);
   return Scaffold(
     backgroundColor: Colors.blue,
     appBar: AppBar(title: Text(""),),
     body:Padding(padding: EdgeInsets.only(left: 20,right: 20,top: 50),
         child: Form(
           key: _formSignUpKey,
         child: ListView(
           children: <Widget>[
             Padding(
               padding: const EdgeInsets.only(left: 30,bottom: 23,top: 0),
               child: Text("Kayıt Ol",style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),),
             ),
             TextFormField(
               decoration: InputDecoration(
                 prefixIcon: Icon(Icons.account_circle,color: Colors.black,),
                 hintText: "Adiniz",
                 labelText: "Ad",
                 border: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
               ),
               onSaved: (deger)=>_ad=deger,
             ),
             SizedBox(height:10),
             TextFormField(
               decoration: InputDecoration(
                 prefixIcon: Icon(Icons.account_circle,color: Colors.black,),
                 hintText: "Soyadiniz",
                 labelText: "Soyad",
                 border: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
               ),

               onSaved: (deger)=>_soyad=deger,
             ),
             SizedBox(height:10),
             TextFormField(
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                 prefixIcon: Icon(Icons.phone,color: Colors.black,),
                 hintText: "Telefon Numaraniz",
                 labelText: "Telefon Numarasi",
                 border: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
               ),

                onSaved:(deger)=>_telefon=deger,
             ),
             SizedBox(height:10),
             TextFormField(
               keyboardType: TextInputType.emailAddress,
               decoration: InputDecoration(
                 errorText: _userModel.emailErrorMessage !=null ?_userModel.emailErrorMessage:null,
                 prefixIcon: Icon(Icons.mail,color: Colors.black,),
                 hintText: "E-Mail Adresiniz",
                 labelText: "E-Mail",
                 border: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
               ),
               onSaved: (deger)=>_email=deger,
             ),
             SizedBox(height:10),
             TextFormField(
               obscureText: true,
               decoration: InputDecoration(
                 errorText: _userModel.passwordErrorMessage !=null ?_userModel.passwordErrorMessage:null,
                 prefixIcon: Icon(Icons.lock,color: Colors.black,),
                 hintText: "Sifreniz",
                 labelText: "Sifre",
                 border: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black,width: 5),
                   borderRadius: BorderRadius.circular(20),
                 ),
               ),
               onSaved: (deger)=>_password=deger,
             ),
             SizedBox(height:20),
             MyButton(buttonText:"Kayıt Ol",
               textColor: Colors.black,
               buttonColor: Colors.yellowAccent,
               onPressed:(){
                 _formSubmit(context);
               },
               buttonIcon: Icon(Icons.supervised_user_circle),
             ),
           ],
         ),
       ),),

   );
  }
  void _showDialog(context){
    showDialog(context:context,builder: (context){
    return AlertDialog(
      title: Row(
        children: [
          Text('Kayit Basarili'),
          Expanded(
            child: FlatButton(
              child: Icon(Icons.close),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: Text('Giris Yapmadan Once Mailinizi Onaylamalisiniz'),
      actions: <Widget>[
        FlatButton(
          child: Text("Tamam"),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  });}
}


