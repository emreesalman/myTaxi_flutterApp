import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPost{
  String postID;
  String userID;
  String userName;
  String userProfileURL;
  String postTitle;
  String postMessage;
  DateTime createdAt;
  final String startLocation,endLocation;
  final String time;
  final String date;
  final int peopleCount;
  bool status;
  MyPost({this.postID,this.userID,this.userName,this.userProfileURL, this.postTitle, this.postMessage, this.createdAt,
  @required this.startLocation,@required this.endLocation,@required this.date, @required this.time,@required this.peopleCount,this.status});

  Map<String,dynamic> toMap(){
    return {
      'postID':postID,
      'userID':userID,
      'userName':userName,
      'userProfileURL':userProfileURL,
      'postTitle':postTitle ?? 'myTaxi Uygulamasi Ile Yolculuk',
      'postMessage':postMessage ?? 'myTaxi Uygulamasi Sayesinde Rahat ve Hesapli Ulasim',
      'createdAt':createdAt ?? FieldValue.serverTimestamp(),
      'startLocation':startLocation,
      'endLocation':endLocation,
      'date':date,
      'time':time,
      'peopleCount':peopleCount,
      'status':status ?? true,
    };
  }

  MyPost.fromMap(Map<String,dynamic>map):
        postID=map['postID'],
        userID=map['userID'],
        userName=map['userName'],
        userProfileURL=map['userProfileURL'],
        postTitle=map['postTitle'],
        postMessage=map['postMessage'],
        createdAt=map['createdAt'],
        startLocation=map['startLocation'],
        endLocation=map['endLocation'],
        time=map['time'],
        date=map['date'],
        peopleCount=map['peopleCount'],
        status=map['status'];

  @override
  String toString() {
    return 'MyPost{postID: $postID, userID: $userID, userName: $userName, userProfileURL: $userProfileURL, postTitle: $postTitle, postMessage: $postMessage, createdAt: $createdAt, startLocation: $startLocation, endLocation: $endLocation, time: $date,time: $time, peopleCount: $peopleCount, status: $status}';
  }
}