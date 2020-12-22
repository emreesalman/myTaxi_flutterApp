
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytaxi/UI/signup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'login.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
StorageUploadTask _uploadTask;
StorageReference _reference=FirebaseStorage.instance.ref();
class profileView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}
class ProfileState extends State<profileView>{

  String _email,_password,_newEmail,_newPassword,_smsCode,_url;
  final FormProfileKey=GlobalKey<FormState>();


  PickedFile _secilenResim;
  var _imagePicker=ImagePicker();
  PickedFile profileImage;
  TextEditingController _controlEmail=new TextEditingController();
  TextEditingController _controlName=new TextEditingController();
  TextEditingController _controlLastName=new TextEditingController();
  TextEditingController _controlPhone=new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controlEmail=TextEditingController();
    _controlName=TextEditingController();
    _controlLastName=TextEditingController();
    _controlPhone=TextEditingController();
  }
  @override
  void dispose() {
    _controlName.dispose();
    _controlLastName.dispose();
    _controlPhone.dispose();
    _controlEmail.dispose();
    super.dispose();

  }
  void _imageFromCamera() async{
    _secilenResim=await _imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      profileImage=_secilenResim;
      Navigator.of(context).pop();
    });
  }

  void _fotoUpload(BuildContext context) async {
    final _userModel=Provider.of<UserModel>(context,listen: false);
    if(profileImage!=null){
      var url= await _userModel.uploadFile(_userModel.user.userID,"profil_foto",File(profileImage.path));
    }
  }
  void _galeridenResimEkle() async{
    profileImage=await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _secilenResim=profileImage;
    });
    try{
      final StorageReference _firebaseStorageRef=FirebaseStorage.instance.ref().child("user").child("profil.jpg");
      final StorageUploadTask task=_firebaseStorageRef.putFile(File(_secilenResim.path));
      var url=await(await task.onComplete).ref.getDownloadURL();
      setState(() {
        _url=url;
      });
      debugPrint("URL "+url.toString());
    }catch(e){
      debugPrint(e.toString());
    }
  }
  void _imageFromGaleri()async{
    setState(() {
      profileImage=_secilenResim;
      Navigator.of(context).pop();
    });
  }
  @override
  Widget build(BuildContext context) {
    UserModel _userModel =Provider.of<UserModel>(context,listen: false);
    _controlEmail.text= _userModel.user.email;
    _controlName.text= _userModel.user.name;
    _controlLastName.text= _userModel.user.lastName;
    _controlPhone.text= _userModel.user.phoneNumber;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    showModalBottomSheet(context: context,builder:(context){
                      return Container(
                        height: 200,
                        child: Column(
                          children: [
                            ListTile(leading: Icon(Icons.camera),
                            title: Text("Kameredan Cek"),
                            onTap: (){
                              _imageFromCamera();

                            },),
                            ListTile(leading: Icon(Icons.image),
                              title: Text("Galeriden Sec"),
                              onTap: (){
                                _imageFromGaleri();

                              },),
                          ],
                        ),
                      );
                    });

                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: _secilenResim==null?NetworkImage(_userModel.user.profileURL):FileImage(File(profileImage.path)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                 initialValue: _userModel.user.email,
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controlName ,
                  decoration: InputDecoration(
                    labelText: "Adiniz",
                    hintText: "AD",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controlLastName ,
                  decoration: InputDecoration(
                    labelText: "Soyadiniz",
                    hintText: "Soyad",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controlPhone ,
                  decoration: InputDecoration(
                    labelText: "Telefon Numaraniz",
                    hintText: "Tel No",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              RaisedButton(
                child: Text("Degisiklikleri Kaydet"),
                onPressed:() {
                  _userdataUpdate(context);
                  _fotoUpload(context);
                },
              )
            ],
          ),
        ),
      )
    );
  }

  void _userdataUpdate(BuildContext context) async{
    final _userModel=Provider.of<UserModel>(context,listen: false);
     var updateResault=await _userModel.updateUserData(_userModel.user.userID, _controlName.text,  _controlLastName.text,  _controlPhone.text);
     if(updateResault==true){
       AlertDialogWidget(
         baslik: "Degisiklikler Kaydedildi",
         icerik: "Bilgileriniz Guncellendi",
         buttonText: "Tamam",
       ).show(context);
     }
     else{
       AlertDialogWidget(
         baslik: "Degisiklik olmadi",
         icerik: "Guncellenirken Hata olustu Daha Sonra Tekrar deneyiniz",
         buttonText: "Tamam",
       ).show(context);
     }
     if(_userModel.user.email!=_controlEmail.text){
       var emailUpdateResault=await _userModel.updateUserEmail(_userModel.user.userID, _controlEmail.text);
       if(emailUpdateResault==true){
         AlertDialogWidget(
           baslik: "Degisiklikler Kaydedildi",
           icerik: "Mail adresiniz guncellendi, sonraki girisinizde onu kullanabilirsiniz",
           buttonText: "Tamam",
         ).show(context);
       }else{
         AlertDialogWidget(
           baslik: "Degisiklik olmadi",
           icerik: "Mail adresiniz guncellenirken hata olustu bilgilerinizi kontrol edin veya farkli bir mail adresi kullanin",
           buttonText: "Tamam",
         ).show(context);
       }
     }
  }


  void _changeEmail() async {
    try{
      await _auth.currentUser.updateEmail(_newEmail);//değişken gelecek//ikinci alan
      debugPrint("E-Mail degisti");
    }on FirebaseAuthException catch(e){

      try{
        //kullanıcı uzun sure oturum açmadı tekrar giremesini istiyoruz
        String email=_email;//birinci alan
        String sifre=_password;   //üçüncü alan
        EmailAuthCredential credential=EmailAuthProvider.credential(email: email, password: sifre);
        await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
        debugPrint("bilgiler doğru");
        await _auth.currentUser.updateEmail(_newEmail);//değişken gelecek//ikinci alan
        debugPrint("Mailinizi onayladiktan sonra yeni e-mailiniz ile tekrar giris yapmaniz gerekiyor email değişti");
        _auth.signOut();
        debugPrint("Kicked");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => loginPageView()),
        );
      }catch(e){
        debugPrint("Hata oluştu $e");
      }
      debugPrint("Hata oluştu $e");
    }
  }
  void _changePassword() async{
    try{
      await _auth.currentUser.updatePassword(_newPassword);//değişken gelecek//üçüncü alan
      debugPrint("şifre değişti");
    }on FirebaseAuthException catch(e){

      try{
        //kullanıcı uzun sure oturum açmadı tekrar giremesini istiyoruz
        String email=_email;//birinci alan
        String sifre=_password;   //ikinci alan
        EmailAuthCredential credential=EmailAuthProvider.credential(email: email, password: sifre);
        await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
        debugPrint("bilgiler doğru");
        await _auth.currentUser.updatePassword(_newPassword);//değişken gelecek//üçüncü alan
        debugPrint("oturum yeniden açıldı şifre değişti");

      }catch(e){
        debugPrint("Hata oluştu $e");
      }

      debugPrint("Hata oluştu $e");
    }
  }

}





