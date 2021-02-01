import 'package:mytaxi/model/user_model.dart';

abstract class AuthBase{
  Future<MyUser> currentUser();
  Future<bool> signOut();
  Future<MyUser> signInWithGoogle();
  Future<MyUser> signInWithEmailAndPassword(String email,String password);
  Future<MyUser> createUserWithEmailAndPassword(String email,String password,String name,String lastName,String phone);
  Future<bool> forgetPassword(String email);
  Future<bool> updateEmail(String email, String newEmail, String password,String userID);
  Future <bool> updatePassword(String email,String password,String newPassword);
}
