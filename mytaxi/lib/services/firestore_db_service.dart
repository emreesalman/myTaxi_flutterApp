
import 'package:flutter/cupertino.dart';
import 'package:mytaxi/model/dm_model.dart';
import 'package:mytaxi/model/message_model.dart';
import 'package:mytaxi/model/post_model.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/services/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDBService implements DBBase{

  final FirebaseFirestore _firestoreAuth =FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser user) async{
   var temp= _firestoreAuth.collection('users').where('userName',isEqualTo: user.userName);
    if(temp==null){
      user.userName=user.userName+'1';
    }
   await _firestoreAuth.collection("users").doc(user.userID).set(user.toMap());
   DocumentSnapshot _readUser=await FirebaseFirestore.instance.doc("users/${user.userID}").get();
   Map _userData=_readUser.data();
   MyUser _userDataObject= MyUser.fromMap(_userData);
   print("okunan User nesnesi from firestore= "+_userDataObject.toString());
   return true;
  }

  @override
  Future<MyUser> readUser(String userID) async{
    DocumentSnapshot _readUser=await _firestoreAuth.collection("users").doc(userID).get();
    Map<String, dynamic> _readUserDataMap=_readUser.data();
    MyUser _readUserObject=MyUser.fromMap(_readUserDataMap);
    print("Okunan User bilgileri : "+_readUserObject.toString());
    return _readUserObject;
  }

  @override
  Future<bool> updateUserData(String userID, String newAd, String newSoyad, String newPhone,String newUserName) async{
    await _firestoreAuth.collection("users").doc(userID).update({"name":newAd});
    await _firestoreAuth.collection("users").doc(userID).update({"lastName":newSoyad});
    await _firestoreAuth.collection("users").doc(userID).update({"phoneNumber":newPhone});
      await _firestoreAuth.collection("users").doc(userID).update({"userName":newUserName});
      return true;



  }

  @override
  Future<bool> updateUserEmail(String userID, String newEmail) async{
     await _firestoreAuth.collection("users").doc(userID).update({'email':newEmail});
     return true;

  }
  Future<bool> updateProfilFoto(String userID,String profilFotoUrl)async{
    await _firestoreAuth.collection("users").doc(userID).update({'profileURL':profilFotoUrl});
    return true;
  }

  @override
  Future<List<MyUser>> getUser(String userID,String searchingUser) async {
    List<MyUser> allUser = [];
      int i=0;

    QuerySnapshot usersFromUserName = await _firestoreAuth.collection("users").where('userName', isGreaterThanOrEqualTo: searchingUser).get();

      if(usersFromUserName.docs.length>0){
        for (DocumentSnapshot user in usersFromUserName.docs) {
          MyUser _user = MyUser.fromMap(user.data());
          if (userID != _user.userID) {
            allUser.add(_user);
            print("okunan veri username "+_user.userID.toString());
          }
        }
        return allUser;
      }
      else{
        QuerySnapshot usersFromName = await _firestoreAuth.collection("users").where("name", isGreaterThanOrEqualTo: searchingUser).get();
        for (DocumentSnapshot users in usersFromName.docs) {
          MyUser _users = MyUser.fromMap(users.data());
          if (userID != _users.userID) {
            allUser.add(_users);
            print("okunan veri name "+_users.userID.toString());
          }
        }
        return allUser;
      }

  }

  @override
  Future<bool> savePost(MyPost post) async{
    var postID= _firestoreAuth.collection('post').doc().id;
    await _firestoreAuth.collection("posts").doc(postID).set(post.toMap());
    await _firestoreAuth.collection("posts").doc(postID).update({
      'postID':postID
    });
    await _firestoreAuth.collection('posts').doc(postID).collection('users').doc(post.userID).set(
        {
          'userID':post.userID,
          "userName":post.userName,
          'userProfileURL':post.userProfileURL,
        });
         return true;
  }


  Future<bool> saveMessages(Message saveMessage) async{

    var _messageID=_firestoreAuth.collection("chats").doc().id;
    var _currentDocID= saveMessage.fromWho+'--'+saveMessage.toWho;
    var _secondDocID=saveMessage.toWho+'--'+saveMessage.fromWho;
    var _saveMessagetoMap=saveMessage.toMap();

    _saveMessagetoMap.update("fromMe", (value) => true );
    await _firestoreAuth.collection('chats')
        .doc(_currentDocID)
        .collection("messages")
        .doc(_messageID)
        .set(_saveMessagetoMap);

    await _firestoreAuth.collection('chats').doc(_currentDocID).set({
      "current_user": saveMessage.fromWho,
      "second_user":saveMessage.toWho,
      "secondUser_name":saveMessage.toWho_name,
      "secondUser_profileURL":saveMessage.toWho_profileURL,
      "last_message":saveMessage.message,
      "created_date":FieldValue.serverTimestamp(),
    });

    _saveMessagetoMap.update("fromMe", (value) => false );
    await _firestoreAuth.collection('chats')
        .doc(_secondDocID)
        .collection("messages")
        .doc(_messageID)
        .set(_saveMessagetoMap);
    await _firestoreAuth.collection('chats').doc(_secondDocID).set({
      "current_user": saveMessage.toWho,
      "second_user":saveMessage.fromWho,
      "last_message":saveMessage.message,
      "created_date":FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<MyChat>> getAllFriend(String userID) async{
    QuerySnapshot querySnapshot=await _firestoreAuth.collection('chats').where('current_user',isEqualTo: userID)
    .orderBy('created_date',descending: true).get();


    List<MyChat> allFriend=[];
    for(DocumentSnapshot docSnapshot in querySnapshot.docs){
      MyChat _docSnapshot=MyChat.fromMap(docSnapshot.data());

      allFriend.add(_docSnapshot);

    }
   return allFriend;
  }

  @override
  Stream<List<Message>> getMessages(String currentUserID,String secondUserID) {
    var snapShot=  _firestoreAuth.collection("chats").doc(currentUserID+"--"+secondUserID)
        .collection("messages").orderBy("date",descending: true).snapshots();
    return snapShot.map((messageList) => messageList.docs.map((message) => Message.fromMap(message.data())).toList());
    // snapshot databaseden gelen mesajlar, mape cevirirken bi degiskene onu atayip messagemodelimi kullanarak modelliyoruz geriye ekranda
    //gosterebilecegimiz bir liste donderiyor.

  }
  @override
  Future<List<MyPost>> userPosts(String userID) async{
    QuerySnapshot querySnapshot=await _firestoreAuth.collection('posts').where('userID',isEqualTo: userID).get();
    List<MyPost> userPosts=[];
    for(DocumentSnapshot documentSnapshot in querySnapshot.docs){
      MyPost _userPosts=MyPost.fromMap(documentSnapshot.data());
      userPosts.add(_userPosts);
    }
    return userPosts;
  }

  @override
  Future<List<MyPost>> getPosts(String userID, MyPost post) async{
    QuerySnapshot querySnapshot=await _firestoreAuth.collection('posts').where('date',isEqualTo: post.date).get();

    List<MyPost> allPost=[];
    for(DocumentSnapshot documentSnapshot in querySnapshot.docs){
      MyPost _post=MyPost.fromMap(documentSnapshot.data());
      if(userID!=_post.userID){
        allPost.add(_post);
      }
    }
    return allPost;
  }



  @override
  Future<bool> joinPost(String userID, String userName, String profileURL, String postID) async{
    QuerySnapshot users=await _firestoreAuth.collection('posts').doc(postID).collection('users').get();
    List<MyPost> allUser=[];
    bool value;
    for(DocumentSnapshot documentSnapshot in users.docs){
      MyPost _user=MyPost.fromMap(documentSnapshot.data());
      if(userID!=_user.userID){
        value=true;
      }
    }
    if(value){
    await _firestoreAuth.collection('posts').doc(postID).collection('users').add({
    'userID':userID,
    'userName':userName,
    'profileURL':profileURL
    });
    QuerySnapshot temp= await _firestoreAuth.collection('posts').doc(postID).collection('users').get();
    if(temp.docs.length>3){
    await _firestoreAuth.collection('posts').doc(postID).update({
    'status':false
    });
    }
    return true;
    }else{
      return false;
    }

  }


}