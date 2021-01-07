import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
class signInWithEmailAndPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EmailAndPasswordLoginState();
  }
}
class EmailAndPasswordLoginState extends State<signInWithEmailAndPassword>{
  String _email,_password;
  final _formKey=GlobalKey<FormState>();
  TextEditingController _controlEmail=new TextEditingController();
  TextEditingController _controlPassword=new TextEditingController();
  _formSubmit(BuildContext context) async{
    if(_controlEmail.text.isNotEmpty&&_controlPassword.text.isNotEmpty){
      try{
        _formKey.currentState.save();
        final _userModel=Provider.of<UserModel>(context,listen: false);
        MyUser _girisYapanUSer= await _userModel.signInWithEmailAndPassword(_email, _password);
        if(_girisYapanUSer!=null) {
          print("Oturum Acan User "+_girisYapanUSer.userID.toString());
        }
        else{
          showDialog(context: context,builder: (context){
            return AlertDialogWidget(
              baslik: "Kullanici Giris Yaparken Hata!",
              icerik: 'Kullanici Bulunamadi veya Hatali Email veya Sifre',
              buttonText: "Tamam",
            );
          });
        }
        if(_userModel.user!=null){
          Navigator.of(context).pop();
        }
      }on FirebaseAuthException catch(e){
        final _userModel=Provider.of<UserModel>(context,listen: false);
        _userModel.state=ViewState.Idle;
        return AlertDialogWidget(
          baslik: 'Giris Yaparken Hata Olustu',
          icerik: e.message.toString(),
          buttonText: 'Tamam',
        ).show(context);
      }
    }else{
      AlertDialogWidget(
        baslik: 'Giris Yaparken Hata Olustu',
        icerik: "Alanlar Bos Gecilemez",
        buttonText: 'Tamam',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userModel=Provider.of<UserModel>(context,listen: true);
    return Scaffold(
      appBar: AppBar(title: Text("Giris Yap"),),
      body:_userModel.state==ViewState.Idle ? Padding(padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height:10),
              TextFormField(
                controller: _controlEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText: _userModel.emailErrorMessage !=null ? _userModel.emailErrorMessage:null,
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
                controller: _controlPassword,
                decoration: InputDecoration(
                  errorText: _userModel.passwordErrorMessage !=null ? _userModel.passwordErrorMessage:null,
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Sifreniz",
                  labelText: "Sifre",
                  border: OutlineInputBorder(),
                ),
                onSaved: (deger)=>_password=deger,
              ),
              RaisedButton(onPressed:()=>_formSubmit(context),
                child: Text("Giris Yap"),
              ),
              RaisedButton(onPressed:()=>_forgetPasswordDialog(context),
                child: Text("Sifremi Unuttum"),
              ),
            ],
          ),
        ),
      ):Center(child: CircularProgressIndicator(),),

    );
  }
  void _forgetPasswordDialog(BuildContext context) {
    showModalBottomSheet(context: context,builder: (context){
      TextEditingController _controlEmail=new TextEditingController();
      final _userModel=Provider.of<UserModel>(context,listen: true);
      bool sonuc;
      return Container(
        height: 600,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controlEmail ,
                decoration: InputDecoration(
                  labelText: "e-Mail Adresiniz",
                  hintText: "e-Mail",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            RaisedButton(
              child: Text('Yolla'),
              onPressed: () async{
                if(_controlEmail.text.isNotEmpty&&_controlEmail.text.contains('@')){
               sonuc= await _userModel.forgetPassword(_controlEmail.text);
                Navigator.pop(context);
                if(sonuc){
                  showDialog(context: context,builder: (context){
                    return AlertDialogWidget(
                      baslik: "Mail Gonderildi",
                      icerik: 'Mailinize Gelen Sifirlama Linkli Ile Sifrenizi Degistirebilirsiniz',
                      buttonText: "Tamam",
                    );
                  });
                }else{
                  showDialog(context: context,builder: (context){
                    return AlertDialogWidget(
                      baslik: "Kayitli Kullanici Bulunamadi",
                      icerik: 'Gecersiz veya Kayitli olmayan e-Mail Adresi',
                      buttonText: "Tamam",
                    );
                  });
                }
                }
              },
            ),
          ],
        ),

      );
    });
  }
}




