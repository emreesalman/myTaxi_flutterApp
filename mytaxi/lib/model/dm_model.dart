import 'package:cloud_firestore/cloud_firestore.dart';

class MyChat{
  final String current_user;
  final String second_user;
  final Timestamp created_date;
  final String last_message;
  String secondUser_name;
  String secondUser_profileURL;

  MyChat(this.current_user, this.second_user, this.created_date, this.last_message);

  Map<String,dynamic> toMap(){
    return {
      'current_user':current_user,
      'second_user':second_user,
      'secondUser_name':secondUser_name,
      'secondUser_profileURL':secondUser_profileURL,
      'last_message':last_message,
      'created_date':created_date ?? FieldValue.serverTimestamp(),
    };
  }
  MyChat.fromMap(Map<String,dynamic>map):
        current_user=map['current_user'],
        second_user=map['second_user'],
        secondUser_name=map['secondUser_name'],
        secondUser_profileURL=map['secondUser_profileURL'],
        last_message=map['last_message'],
        created_date=map['created_date'];

  @override
  String toString() {
    return 'MyChat{current_user: $current_user, second_user: $second_user, created_date: $created_date, last_message: $last_message, secondUser_name: $secondUser_name, secondUser_profileURL: $secondUser_profileURL}';
  }
}