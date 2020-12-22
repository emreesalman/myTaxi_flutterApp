import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/errors.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
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
     MyUser _olusturulanUser= await _userModel.createUserWithEmailAndPassword(_email, _password);
     _olusturulanUser.name=_ad;
     _olusturulanUser.lastName=_soyad;
     _olusturulanUser.phoneNumber=_telefon;
     if(_olusturulanUser!=null){
       print("Olusturulan User "+_olusturulanUser.userID.toString());
     }
   }on PlatformException catch(e){
     print("user olusturulurken hata: "+e.code.toString());

   }
    if(_userModel.user!=null){
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    final _userModel=Provider.of<UserModel>(context,listen: false);
   return Scaffold(
     appBar: AppBar(title: Text("Giris Yap"),),
     body:Padding(padding: EdgeInsets.all(20),
         child: Form(
           key: _formSignUpKey,
         child: ListView(
           children: <Widget>[
             TextFormField(
               decoration: InputDecoration(
                 prefixIcon: Icon(Icons.account_circle),
                 hintText: "Adiniz",
                 labelText: "Ad",
                 border: OutlineInputBorder(),
               ),
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

                onSaved:(deger)=>_telefon=deger,
             ),
             SizedBox(height:10),
             TextFormField(
               keyboardType: TextInputType.emailAddress,
               decoration: InputDecoration(
                 errorText: _userModel.emailErrorMessage !=null ?_userModel.emailErrorMessage:null,
                 prefixIcon: Icon(Icons.mail),
                 hintText: "E-Mail Adresiniz",
                 labelText: "E-Mail",
                 border: OutlineInputBorder(),
               ),
               onSaved: (deger)=>_email=deger,
             ),
             SizedBox(height:10),
             TextFormField(
               obscureText: true,
               decoration: InputDecoration(
                 errorText: _userModel.passwordErrorMessage !=null ?_userModel.passwordErrorMessage:null,
                 prefixIcon: Icon(Icons.lock),
                 hintText: "Sifreniz",
                 labelText: "Sifre",
                 border: OutlineInputBorder(),
               ),
               onSaved: (deger)=>_password=deger,
             ),
             RaisedButton(onPressed:()=>_formSubmit(context),
               child: Text("Kayit Ol"),
             ),
           ],
         ),
       ),),

   );
  }

}


