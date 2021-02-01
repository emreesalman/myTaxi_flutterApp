import 'package:flutter/material.dart';
import 'package:mytaxi/UI/sign_in_with_email_and_password.dart';
import 'package:mytaxi/UI/signup.dart';
import 'package:mytaxi/app/raised_button.dart';
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
        body:SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-24,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child:  Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: AssetImage("assets/images/taxi_icon.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: Text("MYTAXI", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 37,color: Colors.white ,fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Text("ORTAK TAKSI", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30,color: Colors.white ,),),
                  ),
                  SizedBox(height: 10,),
                  MyButton(buttonText:" Giriş Yap",textColor: Colors.white,buttonColor: Colors.blue,
                      onPressed:()=>_signInWithEmailAndPassword(context),
                      buttonIcon: Image.asset("assets/icons/mail_icon.png",fit: BoxFit.contain,height: 30,width:30 ,),
                    ),
                 MyButton(buttonText:"Google Hesabı İle Giriş Yap",textColor: Colors.black,buttonColor: Colors.white,
                      onPressed: ()=>_signInWithGoogle(context),
                      buttonIcon: Image.asset("assets/icons/google.jpg",fit: BoxFit.contain,height: 35,width:35 ,),
                    ),
                  MyButton(buttonText:"Kayıt Ol",textColor: Colors.black,buttonColor: Colors.yellow,
                      onPressed: ()=>_signUp(context),
                      buttonIcon: Icon(Icons.supervised_user_circle),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

}

