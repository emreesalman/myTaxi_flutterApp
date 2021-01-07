
import 'package:mytaxi/model/dm_model.dart';
import 'package:mytaxi/model/post_model.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/model/message_model.dart';

abstract class DBBase {
  Future<bool> saveUser(MyUser user);


  Future<MyUser> readUser(String userID);

  Future<bool> updateUserEmail(String userID, String newEmail);

  Future<bool> updateUserData(String userID, String newAd, String newSoyad,
      String newPhone, String newUserName);

  Future<bool> updateProfilFoto(String userID, String profilFotoUrl);

  Future<List<MyUser>> getUser(String userID, String searchingUser);

  Stream<List<Message>> getMessages(String currentUserID, String secondUserID);

  Future<bool> saveMessages(Message saveMessage);

  Future<List<MyChat>> getAllFriend(String userID);

  Future<bool> savePost(MyPost post);

  Future<List<MyPost>> getPosts(String userID,MyPost post);

  Future<bool> joinPost(String userID,String userName,String profileURL,String postID);

}
