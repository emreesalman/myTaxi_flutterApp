import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message{

  final String fromWho;
  final String toWho;
  final String toWho_name;
  final String toWho_profileURL;
  final bool fromMe;
  final String message;
  final Timestamp date;

  Message({this.fromWho, this.toWho,this.toWho_name,this.toWho_profileURL, this.fromMe, this.message, this.date});

  Map<String,dynamic> toMap(){
    return {
      'fromWho':fromWho,
      'toWho':toWho,
      'toWho_name':toWho_name,
      'toWho_profileURL':toWho_profileURL,
      'fromMe':fromMe,
      'message':message,
      'date':date ?? FieldValue.serverTimestamp(),
    };
  }
  Message.fromMap(Map<String,dynamic>map):
        fromWho=map['fromWho'],
        toWho=map['toWho'],
        toWho_name=map['toWho_name'],
        toWho_profileURL=map['toWho_profileURL'],
        fromMe=map['fromMe'],
        message=map['message'],
        date=map['date'];

  @override
  String toString() {
    return 'Message{fromWho: $fromWho, toWho: $toWho, toWho_name: $toWho_name, toWho_profileURL: $toWho_profileURL, fromMe: $fromMe, message: $message, date: $date}';
  }
}