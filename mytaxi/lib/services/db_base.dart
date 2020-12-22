
import 'package:mytaxi/model/user_model.dart';

abstract class DBBase{
  Future<bool> saveUser(MyUser user);
  Future<bool> saveUser1(MyUser user);
  Future<MyUser> readUser(String userID);
  Future<bool> updateUserEmail(String userID, String newEmail);
  Future<bool> updateUserData(String userID,String newAd,String newSoyad,String newPhone);

}
