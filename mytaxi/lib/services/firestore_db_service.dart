
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/services/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDBService implements DBBase{

  final FirebaseFirestore _firestoreAuth =FirebaseFirestore.instance;
  @override
  Future<bool> saveUser1(MyUser user) async{
    await _firestoreAuth.collection("users").doc(user.userID).set(user.toMap());
    return true;
  }
  @override
  Future<bool> saveUser(MyUser user) async{
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
  Future<bool> updateUserData(String userID, String newAd, String newSoyad, String newPhone) async{
    await _firestoreAuth.collection("users").doc(userID).update({"name":newAd});
    await _firestoreAuth.collection("users").doc(userID).update({"lastName":newSoyad});
    await _firestoreAuth.collection("users").doc(userID).update({"phoneNumber":newPhone});
    return true;
  }

  @override
  Future<bool> updateUserEmail(String userID, String newEmail) async{
   var users=await _firestoreAuth.collection("users").where("email",isEqualTo: newEmail).get();
   if(users.docs.length>=1){
     return false;
   }else{
     await _firestoreAuth.collection("users").doc(userID).update({'email':newEmail});
     return true;
     //buraya firebase kullanici changemaili gelecek..
   }
  }
  Future<bool> updateProfilFoto(String userID,String profilFotoUrl)async{
    await _firestoreAuth.collection("users").doc(userID).update({'profileURL':profilFotoUrl});
    return true;
  }


  
}