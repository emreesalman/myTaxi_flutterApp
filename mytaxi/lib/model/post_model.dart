import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyPost{
  String postID;
  String userID;
  String userName;
  String userProfileURL;
  String postTitle;
  String postMessage;
  DateTime createdAt;
  String starAdress;
  String endAdress;
  final double startLocationLat,startLocationLong,endLocationLat,endLocationLong;
  final String time;
  final String date;
  final int peopleCount;
  bool status;

  MyPost({this.postID,this.userID,this.userName,this.userProfileURL, this.postTitle, this.postMessage, this.createdAt,
    this.starAdress,this.endAdress,
  @required this.startLocationLat,@required this.startLocationLong,
    @required this.endLocationLat,@required this.endLocationLong,
    @required this.date, @required this.time,@required this.peopleCount,this.status});

  Map<String,dynamic> toMap(){
    return {
      'postID':postID,
      'userID':userID,
      'userName':userName,
      'userProfileURL':userProfileURL,
      'postTitle':postTitle ?? 'myTaxi Uygulamasi Ile Yolculuk',
      'postMessage':postMessage ?? 'myTaxi Uygulamasi Sayesinde Rahat ve Hesapli Ulasim',
      'createdAt':createdAt ?? FieldValue.serverTimestamp(),
      'starAdress':starAdress,
      'endAdress':endAdress,
      'startLocationLat':startLocationLat,
      'startLocationLong':startLocationLong,
      'endLocationLat':endLocationLat,
      'endLocationLong':endLocationLong,
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
        startLocationLat=map['startLocationLat'],
        startLocationLong=map['startLocationLong'],
        endLocationLat=map['endLocationLat'],
        endLocationLong=map['endLocationLong'],
        starAdress=map['starAdress'],
        endAdress=map['endAdress'],
        time=map['time'],
        date=map['date'],
        peopleCount=map['peopleCount'],
        status=map['status'];

  @override
  String toString() {
    return 'MyPost{postID: $postID, userID: $userID, userName: $userName, userProfileURL: $userProfileURL, postTitle: $postTitle, postMessage: $postMessage, starAdress: $starAdress, endAdress: $endAdress, startLocationLat: $startLocationLat, startLocationLong: $startLocationLong, endLocationLat: $endLocationLat, endLocationLong: $endLocationLong, time: $time, date: $date, peopleCount: $peopleCount, status: $status}';
  }
}