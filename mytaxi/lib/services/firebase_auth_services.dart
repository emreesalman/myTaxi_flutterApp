import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  @override
  Future<MyUser> currentUser() async{
    User user= await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }
  MyUser _userFromFirebase(User user){
    try{
      if(user==null){
        return null;
      }else{
        return MyUser(userID: user.uid,email: user.email);
      }
    }catch(e){
      print("HATA CurrentUser firebase_auth_services"+e.toString());
      return null;
    }
  }
  @override
  Future<bool> signOut() async{
    try{
      final _googleSignIn=GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    }catch(e){
      print("HATA SignOut firebase_auth_services"+e.toString());
      return false;
    }
  }
  @override
  Future<MyUser> signInWithGoogle() async{
    GoogleSignIn _googleSignIn=GoogleSignIn();
    GoogleSignInAccount _googleUser=await _googleSignIn.signIn();

    if(_googleUser!=null){
      GoogleSignInAuthentication _googleAuth=await _googleUser.authentication;
      if(_googleAuth.idToken!=null&&_googleAuth.accessToken!=null){
        var sonuc=  await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(idToken:_googleAuth.idToken,accessToken:_googleAuth.accessToken)
        );
        User _user=sonuc.user;
        return _userFromFirebase(_user);
      }
    }else{
      return null;
    }
  }
  @override
  Future<MyUser> createUserWithEmailAndPassword(String email, String password,String name,String lastName,String phone) async{
      var _user=await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _user.user.sendEmailVerification();
        return _userFromFirebase(_user.user);

  }


  @override
  Future<MyUser> signInWithEmailAndPassword(String email, String password)async {
       var _user =await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
       if(_user.user.emailVerified){
         return _userFromFirebase(_user.user);
       }
       else{
         return null;
       }
  }

  @override
  Future<bool> forgetPassword(String email) async{
    try{
      _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    }catch(e){
      print('Sifremi unuttum hata'+e.toString());
      return false;
    }

  }

  @override
  Future<bool> updateEmail(String email, String newEmail, String password,String userID) async{
    try{
      await _firebaseAuth.currentUser.updateEmail(newEmail);
      print("E-Mail degisti");
      return true;
    }on FirebaseAuthException catch(e){
      try{
        //kullanıcı uzun sure oturum açmdadı tekrar giremesini istiyoruz
        EmailAuthCredential credential=EmailAuthProvider.credential(email: email, password: password);
        await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
        await _firebaseAuth.currentUser.updateEmail(newEmail);
        print("Mailinizi onayladiktan sonra yeni e-mailiniz ile tekrar giris yapmaniz gerekiyor email değişti");
        return true;
      }catch(e){
        print("Hata oluştu $e");
        return false;
      }
    }
  }

  @override
  Future<bool> updatePassword(String email, String password, String newPassword) async{
    try{
      await _firebaseAuth.currentUser.updatePassword(newPassword);
      return true;
    }on FirebaseAuthException catch(e){
      try{
        EmailAuthCredential credential=EmailAuthProvider.credential(email: email, password: password);
        await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
        await _firebaseAuth.currentUser.updatePassword(newPassword);
        print("şifre değişti");
        return true;

      }catch(e){
        print("Hata oluştu $e");
        return false;
      }
    }
  }



}