import 'package:mytaxi/app/locator.dart';
import 'package:mytaxi/model/dm_model.dart';
import 'package:mytaxi/model/message_model.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/services/auth_base.dart';
import 'package:mytaxi/services/firebase_auth_services.dart';
import 'package:mytaxi/services/firebase_storage_services.dart';
import 'package:mytaxi/services/firestore_db_service.dart';
import 'package:mytaxi/model/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:mytaxi/viewmodel/user_view_model.dart';

enum AppMode{DEBUG,RELEASE}



class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService = locator<
      FirebaseStorageService>();
  String _error;
  AppMode appMode = AppMode.RELEASE;

  Future<MyUser> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=CurrentUser");
      return null;
    }
    else {
      MyUser _user = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user.userID);
    }
  }

  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=SignOut");
      return null;
    }
    else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<MyUser> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=SignInWithGoogle");
      return null;
    }
    else {
      MyUser _user = await _firebaseAuthService.signInWithGoogle();
      bool sonuc = await _firestoreDBService.saveUser(_user);
      if (sonuc) {
        print("Firestore Kayit basarili with google");
        return await _firestoreDBService.readUser(_user.userID);
      } else {
        print("FireStore kayit basarisiz oldu");
        return null;
      }
    }
  }

  @override
  Future<MyUser> createUserWithEmailAndPassword(String email, String password,
      String name, String lastName, String phone) async {
    if (appMode == AppMode.DEBUG) {
      print(
          "appMode debug modda herhangi bir database yok=CreateUserwEmail/Pass");
      return null;
    }
    else {
      MyUser _user = await _firebaseAuthService.createUserWithEmailAndPassword(
          email, password, name, lastName, phone);
      _user.name = name;
      _user.lastName = lastName;
      _user.phoneNumber = phone;
      bool sonuc = await _firestoreDBService.saveUser(_user);
      if (sonuc == true) {
        print("Firestore Kayit basarili");
        return await _firestoreDBService.readUser(_user.userID);
      } else {
        print("FireStore kayit basarisiz oldu");
        return null;
      }
    }
  }


  String get error=>_error;


  @override
  Future<MyUser> signInWithEmailAndPassword(String email,
      String password) async {
      if (appMode == AppMode.DEBUG) {
        print(
            "appMode debug modda herhangi bir database yok=SignInwEmail/Pass");
        return null;
      }
      else {
        MyUser _user = await _firebaseAuthService.signInWithEmailAndPassword(
            email, password);
        if (_user != null) {
          return await _firestoreDBService.readUser(_user.userID);
        }
        else {
          return null;
        }
      }
  }

  Future<bool> updateUserData(String userID, String newAd, String newSoyad,
      String newPhone, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return false;
    }
    else {
      return await _firestoreDBService.updateUserData(
          userID, newAd, newSoyad, newPhone, newUserName);
    }
  }


  Future<String> uploadFile(String userID, String fileType,
      File profileImage) async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return null;
    } else {
      var profilFotoUrl = await _firebaseStorageService.uploadFile(
          userID, fileType, profileImage);
      await _firestoreDBService.updateProfilFoto(userID, profilFotoUrl);
      return profilFotoUrl;
    }
  }

  Future<List<MyUser>> getUser(String userID, String searchingUser) {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return null;
    } else {
      var userList = _firestoreDBService.getUser(userID, searchingUser);
      return userList;
    }
  }

  Stream<List<Message>> getMessages(String currentUserID, String secondUserID) {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=getMessages");
      return null;
    } else {
      return _firestoreDBService.getMessages(currentUserID, secondUserID);
    }
  }

  Future<bool> saveMessage(Message saveMessage) async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=saveMessage");
      return true;
    } else {
      return _firestoreDBService.saveMessages(saveMessage);
    }
  }

  Future<List<MyChat>> getAllFriend(String userID) async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=saveMessage");
      return null;
    } else {
      return await _firestoreDBService.getAllFriend(userID);
    }
  }

  @override
  Future<bool> forgetPassword(String email) async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=forgetPassword");
      return null;
    } else {
      return await _firebaseAuthService.forgetPassword(email);
    }
  }
  Future<bool> savePost(MyPost post) async {
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=forgetPassword");
      return null;
    } else {
      return await _firestoreDBService.savePost(post);
    }
  }
  Future<List<MyPost>> getPosts(String userID, MyPost post) async{
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=saveMessage");
      return null;
    } else {
      return await _firestoreDBService.getPosts(userID, post);
    }
  }
  Future<bool> joinPost(String userID, String userName, String profileURL, String postID) async{
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=saveMessage");
      return null;
    } else {
      return await _firestoreDBService.joinPost(userID, userName, profileURL, postID);
    }
  }

  @override
  Future<bool> updateEmail(String email, String newEmail, String password,String userID) async{
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return false;
    } else {
      bool sonuc=await _firebaseAuthService.updateEmail(email, newEmail, password, userID);
      if(sonuc==true){
        await _firestoreDBService.updateUserEmail(userID, newEmail);
      }
      else{
        return false;
      }
    }
  }

  @override
  Future<bool> updatePassword(String email, String password, String newPassword)  async{
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return false;
    } else {
      return await _firebaseAuthService.updatePassword(email, password, newPassword);
    }
  }
  Future<List<MyPost>> userPosts(String userID) async{
    if (appMode == AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return null;
    } else {
      return await _firestoreDBService.userPosts(userID);
    }
  }

}

