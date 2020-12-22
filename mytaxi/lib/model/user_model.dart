import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser{
  final String userID;
  String name,lastName,email,phoneNumber,profileURL;
  DateTime createdAt,updatedAt;
  MyUser({@required this.userID,@required this.email});

  Map<String, dynamic> toMap(){

  return {
    'userID': userID,
    'name': name?? '',
    'lastName': lastName ?? '',
    'email': email,
    'phoneNumber': phoneNumber ?? '',
    'profileURL' : profileURL ?? 'https://www.avm.gen.tr/resimler/big_yellow_taxi_0.jpg',
    'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    'updatedAt': updatedAt?? FieldValue.serverTimestamp(),
  };
}

  MyUser.fromMap(Map<String,dynamic>map):
        userID=map['userID'],
        name=map['name'],
        lastName=map['lastName'],
        email=map['email'],
        phoneNumber=map['phoneNumber'],
        profileURL=map['profileURL'],
        createdAt=(map['createdAt'] as Timestamp).toDate(),
        updatedAt=(map['updatedAt'] as Timestamp).toDate();

  @override
  String toString() {
    return 'MyUser{userID: $userID, name: $name, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

