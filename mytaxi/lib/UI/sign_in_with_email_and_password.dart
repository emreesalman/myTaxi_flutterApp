import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/raised_button.dart';
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
              baslik: "Kullanıcı Giriş Yaparken Hata Oluştu !",
              icerik: 'Kullanıcı Bulunamadı veya Hatalı E-Mail/Şifre',
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
          baslik: 'Giriş Yaparken Hata Oluştu',
          icerik: e.message.toString(),
          buttonText: 'Tamam',
        ).show(context);
      }
    }else{
      AlertDialogWidget(
        baslik: 'Giriş Yaparken Hata Oluştu',
        icerik: "Alanlar Boş Geçilemez",
        buttonText: 'Tamam',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userModel=Provider.of<UserModel>(context,listen: true);
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: Text("Giriş Yap",textAlign: TextAlign.center,),),
      body:_userModel.state==ViewState.Idle ?
      Padding(padding: EdgeInsets.only(left: 20,right: 20,top:0),
          child:Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children:<Widget>[
                          Container(
                              padding:EdgeInsets.fromLTRB(15.0, 90.0, 0.0, 0.0),
                              child: Text("HOŞ",style: TextStyle(fontSize: 60,color: Colors.white,fontWeight: FontWeight.bold ),)
                          ),
                          Container(
                              padding:EdgeInsets.fromLTRB(20.0, 152.0, 0.0, 0.0),
                              child: Text("-geldiniz",style: TextStyle(fontSize: 55,color: Colors.white,),)
                          ),

                        ],
                      )
                    ),
                    SizedBox(height:10),
                    TextFormField(
                      controller: _controlEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        errorText: _userModel.emailErrorMessage !=null ? _userModel.emailErrorMessage:null,
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
                      controller: _controlPassword,
                      decoration: InputDecoration(
                        errorText: _userModel.passwordErrorMessage !=null ? _userModel.passwordErrorMessage:null,
                        prefixIcon: Icon(Icons.lock,color: Colors.black,),
                        hintText: "Şireniz",
                        labelText: "Şifre",
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
                    SizedBox(height:22),
                    MyButton(buttonText:"Giriş Yap",
                      textColor: Colors.black,
                      buttonColor: Colors.yellow,
                      onPressed:()=>_formSubmit(context),
                      buttonIcon: Icon(Icons.login_sharp),
                    ),

                    MyButton(buttonText:"Şifremi Unuttum",
                      textColor: Colors.black,
                      buttonColor: Colors.lightBlueAccent,
                      onPressed:()=>_forgetPasswordDialog(context),
                      buttonIcon: Icon(Icons.replay_circle_filled),
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
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controlEmail ,
                decoration: InputDecoration(
                  labelText: "E-Mail Adresiniz",
                  hintText: "E-Mail",
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




