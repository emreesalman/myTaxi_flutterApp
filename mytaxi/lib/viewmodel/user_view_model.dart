
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'file:///C:/Users/Emre/Desktop/myTaxi/mytaxi/lib/app/locator.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/repository/user_repository.dart';
import 'package:mytaxi/services/auth_base.dart';

enum ViewState{Idle,Busy}

class UserModel extends ChangeNotifier implements AuthBase{
  ViewState _state =ViewState.Idle;
  UserRepository _userRepository=locator<UserRepository>();
  MyUser _user;
  String emailErrorMessage,passwordErrorMessage;

  MyUser get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }
  UserModel(){
    currentUser();
  }

  @override
  Future<MyUser> currentUser() async{
    try{
      state=ViewState.Busy;
     _user= await _userRepository.currentUser();
      return _user;
    }catch(e){
      debugPrint("View Model  CurrentUser hata.. "+e.toString());
      return null;
    }finally{
      state=ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut()async {
    try {
      state = ViewState.Busy;
      await _userRepository.signOut();
      _user=null;
    } catch (e) {
      debugPrint("View Model  CurrentUser hata.. " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser> signInWithGoogle() async{
    try{
      state=ViewState.Busy;
      _user= await _userRepository.signInWithGoogle();
      return _user;
    }catch(e){
      debugPrint("View Model SignInWithGoogle hata.. "+e.toString());
      return null;
    }finally{
      state=ViewState.Idle;
    }
  }

  @override
  Future<MyUser> createUserWithEmailAndPassword(String email, String password) async{
      if(_emailPasswordControl(email, password)==true){
        try{
          state=ViewState.Busy;
          _user= await _userRepository.createUserWithEmailAndPassword(email, password);
          return _user;
        }finally{
          state=ViewState.Idle;
        }
      }else{
        return null;
      }
  }
  @override
  Future<MyUser> signInWithEmailAndPassword(String email, String password) async{
      if(_emailPasswordControl(email, password)==true){
        state=ViewState.Busy;
        _user= await _userRepository.signInWithEmailAndPassword(email, password);
        state=ViewState.Idle;
        return _user;
      }else{
        return null;
      }
  }

  bool _emailPasswordControl(String email, String password){
    var sonuc =true;
    if(password.length<6 ){
      passwordErrorMessage ="Sifre en az 6 karakterli olmali";
      sonuc=false;
    }else{
      passwordErrorMessage=null;
    }
    if(!email.contains('@')){
      emailErrorMessage ="Gecersiz email adresi";
      sonuc=false;
    }else{
      emailErrorMessage=null;
    }
    return sonuc;
  }
  Future<bool> updateUserData(String userID, String newAd, String newSoyad, String newPhone) async{
    var sonuc= await _userRepository.updateUserData(userID, newAd, newSoyad, newPhone);
    if(sonuc){
    _user.name=newAd;
    _user.lastName=newSoyad;
    _user.phoneNumber=newPhone;
    }
    return sonuc;
  }
  Future<bool> updateUserEmail(String userID,String newEmail)async{
    var sonuc= await _userRepository.updateUserEmail(userID, newEmail);
    return sonuc;
  }

  Future<String> uploadFile(String userID, String fileType, File profileImage) async {
    var link= await _userRepository.uploadFile(userID, fileType,profileImage);
    return link;
  }

}