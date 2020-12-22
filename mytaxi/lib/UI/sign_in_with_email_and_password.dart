import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/errors.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
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

  _formSubmit(BuildContext context) async{

    _formKey.currentState.save();
    final _userModel=Provider.of<UserModel>(context,listen: false);
    try{
      MyUser _girisYapanUSer= await _userModel.signInWithEmailAndPassword(_email, _password);
      if(_girisYapanUSer!=null) {
        print("Oturum Acan User "+_girisYapanUSer.userID.toString());
      }
    }on PlatformException catch(e){
      print("oturum acarken Hata: "+Errors.showError(e.code));
      showDialog(context: context,builder: (context){
        return AlertDialogWidget(
          baslik: "Kullanici Giris Yaparken Hata!",
          icerik: Errors.showError(e.code),
          buttonText: "Tamam",
        );
      });
    }
    if(_userModel.user!=null){
      Navigator.of(context).pop();
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
                child: Text("Giris Yap"),
              ),
            ],
          ),
        ),
      ):Center(child: CircularProgressIndicator(),),

    );
  }
}


