
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytaxi/model/dm_model.dart';
import 'package:mytaxi/model/message_model.dart';
import 'file:///C:/Users/Emre/Desktop/myTaxi/mytaxi/lib/app/locator.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/repository/user_repository.dart';
import 'package:mytaxi/services/auth_base.dart';
import 'package:mytaxi/model/post_model.dart';

enum ViewState{Idle,Busy}

class UserModel extends ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  MyUser _user;
  String emailErrorMessage, passwordErrorMessage;


  MyUser get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<MyUser> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      state = ViewState.Idle;
      debugPrint("View Model  CurrentUser hata.. " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      await _userRepository.signOut();
      _user = null;
    } catch (e) {
      debugPrint("View Model  SignOut hata.. " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (e) {
      debugPrint("View Model SignInWithGoogle hata.. " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser> createUserWithEmailAndPassword(String email, String password,
      String name, String lastName, String phone) async {
    if (_emailPasswordControl(email, password) == true) {
      try {
        state = ViewState.Busy;
        _user = await _userRepository.createUserWithEmailAndPassword(
            email, password, name, lastName, phone);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else {
      return null;
    }
  }

  @override
  Future<List<MyUser>> getUser(String userID,String searchingUser) async {
    var userList = await _userRepository.getUser(userID,searchingUser);
    return userList;
  }

  Future<MyUser> signInWithEmailAndPassword(String email,
      String password) async {
      if (_emailPasswordControl(email, password) == true) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailAndPassword(email, password);
        state = ViewState.Idle;
        return _user;
      } else {
        return null;
      }
  }

  bool _emailPasswordControl(String email, String password) {
    var sonuc = true;
    if (password.length < 6) {
      passwordErrorMessage = "Sifre en az 6 karakterli olmali";
      sonuc = false;
    } else {
      passwordErrorMessage = null;
    }
    if (!email.contains('@')) {
      emailErrorMessage = "Gecersiz email adresi";
      sonuc = false;
    } else {
      emailErrorMessage = null;
    }
    return sonuc;
  }

  Future<bool> updateUserData(String userID, String newAd, String newSoyad,
      String newPhone,String newUserName) async {
    var sonuc = await _userRepository.updateUserData(
        userID, newAd, newSoyad, newPhone,newUserName);
    if (sonuc) {
      _user.name = newAd;
      _user.lastName = newSoyad;
      _user.phoneNumber = newPhone;
      _user.userName=newUserName;
    }
    return sonuc;
  }

  Future<String> uploadFile(String userID, String fileType,
      File profileImage) async {
    var link = await _userRepository.uploadFile(userID, fileType, profileImage);
    return link;
  }

  Stream<List<Message>> getMessages(String currentUserID, String secondUserID) {
    return _userRepository.getMessages(currentUserID,secondUserID);

  }

  Future<bool> saveMessage(Message saveMessage) async {
    return await _userRepository.saveMessage(saveMessage);
  }

  Future<List<MyChat>>getAllFriend(String userID) async{
    return await _userRepository.getAllFriend(userID);
  }

  @override
  Future<bool> forgetPassword(String email) async {
    return await _userRepository.forgetPassword(email);
  }
  Future<bool> savePost(MyPost post) async {
    return await _userRepository.savePost(post);
  }
  Future<List<MyPost>> getPosts(String userID, MyPost post) async{
    return await _userRepository.getPosts(userID, post);
  }
  Future<bool> joinPost(String userID, String userName, String profileURL, String postID) async{
    return await _userRepository.joinPost(userID, userName, profileURL, postID);
  }

  @override
  Future<bool> updateEmail(String email, String newEmail, String password,String userID) async {
   return await _userRepository.updateEmail(email, newEmail, password, userID);
  }

  @override
  Future<bool> updatePassword(String email, String password, String newPassword) async {
    return await _userRepository.updatePassword(email, password, newPassword);
  }
  Future<List<MyPost>> userPosts(String userID) async{
    return await _userRepository.userPosts(userID);
  }

}
