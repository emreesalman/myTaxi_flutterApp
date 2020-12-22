import 'package:flutter/material.dart';
import 'package:mytaxi/UI/homepage.dart';
import 'package:mytaxi/UI/login.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {

  @override
    Widget build(BuildContext context) {
    final _userModel =Provider.of<UserModel>(context, listen: true);
    if(_userModel.state==ViewState.Idle){
      if(_userModel.user==null){
        return loginPageView();
      }else{
        print("Oturum Acan User "+_userModel.user.userID.toString());
        return homePageView(user: _userModel.user);
      }
    }else{
      return Scaffold(
         body: Center(child: CircularProgressIndicator(),),
      );
    }
}
}
