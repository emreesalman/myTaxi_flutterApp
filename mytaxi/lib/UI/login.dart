import 'package:flutter/material.dart';
import 'package:mytaxi/UI/sign_in_with_email_and_password.dart';
import 'package:mytaxi/UI/signup.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';

class loginPageView extends StatelessWidget {

  void _signInWithGoogle(BuildContext context) async{
    final _userModel=Provider.of<UserModel>(context, listen: false);
    MyUser _user=await _userModel.signInWithGoogle();
    if(_user!=null) print("Oturum Acan User "+_user.userID.toString());
  }
  void _signInWithEmailAndPassword(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context)=>signInWithEmailAndPassword(),),);
  }
  void _signUp(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context)=>SignUpView(),),);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Giris Yap"), elevation: 0,),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Oturum Acma Yontemi", textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            RaisedButton(onPressed:()=>_signInWithEmailAndPassword(context),
              child: Text("Mail ve Sifre Ile"),
            ),
            RaisedButton(onPressed: ()=>_signInWithGoogle(context),
              child: Text("Google Hesabi Ile"),
            ),
            RaisedButton(onPressed: ()=>_signUp(context),
              child: Text("Kayit Ol"),
            ),
          ],
        )
    );
  }

}

