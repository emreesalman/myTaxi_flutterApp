import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser{
   String userID;
  String name,lastName,email,phoneNumber,profileURL,userName;
  DateTime createdAt,updatedAt;
  MyUser({@required this.userID,this.userName,this.name,this.lastName,@required this.email,this.phoneNumber});

  Map<String, dynamic> toMap(){

  return {
    'userID': userID,
    'userName':userName ?? email.substring(0,email.indexOf('@'))+randomNumber(),
    'name': name?? '',
    'lastName': lastName ?? '',
    'email': email,
    'phoneNumber': phoneNumber ?? '',
    'profileURL' : profileURL ?? 'https://firebasestorage.googleapis.com/v0/b/mytaxi-6e782.appspot.com/o/yVTnQZixyqNG2imMkcSjwhvOAMv1%2Fprofil_foto%2Fprofil_foto.png?alt=media&token=13f67b9a-da7c-47ec-b930-b37e42d58fe1',
    'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    'updatedAt': updatedAt?? FieldValue.serverTimestamp(),
  };
}

  MyUser.fromMap(Map<String,dynamic>map):
        userID=map['userID'],
        userName=map['userName'],
        name=map['name'],
        lastName=map['lastName'],
        email=map['email'],
        phoneNumber=map['phoneNumber'],
        profileURL=map['profileURL'],
        createdAt=(map['createdAt'] as Timestamp).toDate(),
        updatedAt=(map['updatedAt'] as Timestamp).toDate();

  @override
  String toString() {
    return 'MyUser{userID: $userID,userName:$userName, name: $name, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  MyUser.data({@required this.userID,@required this.userName,@required this.profileURL,});

  String randomNumber(){
    int randomSayi =Random().nextInt(9999999);
    return randomSayi.toString();
  }
}

