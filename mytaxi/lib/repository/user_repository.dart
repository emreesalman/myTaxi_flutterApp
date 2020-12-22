import 'dart:io';

import 'package:mytaxi/app/locator.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/services/auth_base.dart';
import 'package:mytaxi/services/firebase_auth_services.dart';
import 'package:mytaxi/services/firebase_storage_services.dart';
import 'package:mytaxi/services/firestore_db_service.dart';
import 'package:image_picker/image_picker.dart';


enum AppMode{DEBUG,RELEASE}

class UserRepository implements AuthBase{
  FirebaseAuthService _firebaseAuthService=locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService=locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService=locator<FirebaseStorageService>();


  AppMode appMode= AppMode.RELEASE;

  Future<MyUser> currentUser() async{
    if(appMode==AppMode.DEBUG)
      {
        print("appMode debug modda herhangi bir database yok=CurrentUser");
        return null;
      }
    else{
      MyUser _user= await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user.userID);
    }
  }

  Future<bool> signOut()async {
    if(appMode==AppMode.DEBUG){
      print("appMode debug modda herhangi bir database yok=SignOut");
      return null;
    }
    else{
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<MyUser> signInWithGoogle() async {
    if(appMode==AppMode.DEBUG)
    {
      print("appMode debug modda herhangi bir database yok=SignInWithGoogle");
      return null;
    }
    else{
      MyUser _user=await _firebaseAuthService.signInWithGoogle();
      bool sonuc=await _firestoreDBService.saveUser(_user);
      if(sonuc){
        print("Firestore Kayit basarili with google");
        return await _firestoreDBService.readUser(_user.userID);
      }else{
        print("FireStore kayit basarisiz oldu");
        return null;
      }
    }
  }

  @override
  Future<MyUser> createUserWithEmailAndPassword(String email, String password)async {
    if(appMode==AppMode.DEBUG)
    {
      print("appMode debug modda herhangi bir database yok=CreateUserwEmail/Pass");
      return null;
    }
    else{
        MyUser _user= await _firebaseAuthService.createUserWithEmailAndPassword(email, password);
        bool sonuc=await _firestoreDBService.saveUser(_user);
        if(sonuc=true){
          print("Firestore Kayit basarili");
          return  await _firestoreDBService.readUser(_user.userID);
        }else {
          print("FireStore kayit basarisiz oldu");
          return null;
        }
    }
  }

  @override
  Future<MyUser> signInWithEmailAndPassword(String email, String password)async {
    if(appMode==AppMode.DEBUG)
    {
      print("appMode debug modda herhangi bir database yok=SignInwEmail/Pass");
      return null;
    }
    else{
        MyUser _user= await _firebaseAuthService.signInWithEmailAndPassword(email, password);
        return await _firestoreDBService.readUser(_user.userID);
    }
  }
  Future<bool> updateUserData(String userID, String newAd, String newSoyad, String newPhone)async{
    if(appMode==AppMode.DEBUG)
    {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return false;
    }
    else{
      return await _firestoreDBService.updateUserData(userID,newAd,newSoyad,newPhone);
    }
  }
  Future<bool> updateUserEmail(String userID, String newEmail) async{
    if(appMode==AppMode.DEBUG)
    {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return false;
  }else{
      return await _firestoreDBService.updateUserEmail(userID, newEmail);
    }
  }

  Future<String> uploadFile(String userID, String fileType, File profileImage) async{
    if(appMode==AppMode.DEBUG) {
      print("appMode debug modda herhangi bir database yok=updateUserEmail");
      return null;
    }else{
      var profilFotoUrl=await _firebaseStorageService.uploadFile(userID, fileType, profileImage);
        await _firestoreDBService.updateProfilFoto(userID,profilFotoUrl);
       return profilFotoUrl;
    }
  }

}


