
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/raised_button.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'login.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
class profileView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}
class ProfileState extends State<profileView>{

  String _email;
  final FormProfileKey=GlobalKey<FormState>();


  PickedFile _secilenResim;
  var _imagePicker=ImagePicker();
  PickedFile profileImage;
  TextEditingController _controlEmail=new TextEditingController();
  TextEditingController _controlName=new TextEditingController();
  TextEditingController _controlLastName=new TextEditingController();
  TextEditingController _controlPhone=new TextEditingController();
  TextEditingController _controlUserName=new TextEditingController();
  TextEditingController _emailUpdateControl=new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controlUserName=TextEditingController();
    _controlEmail=TextEditingController();
    _controlName=TextEditingController();
    _controlLastName=TextEditingController();
    _controlPhone=TextEditingController();
    _emailUpdateControl=new TextEditingController();

  }
  @override
  void dispose() {
    _controlName.dispose();
    _controlLastName.dispose();
    _controlPhone.dispose();
    _controlEmail.dispose();
    _controlUserName.dispose();
    _emailUpdateControl.dispose();
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
  void _imageFromGaleri()async{
    _secilenResim=await _imagePicker.getImage(source: ImageSource.gallery);
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
    _controlUserName.text=_userModel.user.userName;
    _emailUpdateControl.text=_userModel.user.email;
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

                                  },
                                ),
                              ],
                            ),
                          );
                        }
                        );
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _secilenResim==null?NetworkImage(_userModel.user.profileURL):FileImage(File(profileImage.path)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controlEmail,
                      decoration: InputDecoration(
                        labelText: "E-Mailiniz",
                        hintText: "E-Mail",
                        border:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green,width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controlUserName ,
                      decoration: InputDecoration(
                        labelText: "Kullanıcı Adınız",
                        hintText: "Kullanıcı Adı",
                        border:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green,width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controlName ,
                      decoration: InputDecoration(
                        labelText: "Adınız",
                        hintText: "Ad",
                        border:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green,width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controlLastName ,
                      decoration: InputDecoration(
                        labelText: "Soyadınız",
                        hintText: "Soyad",
                        border:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green,width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controlPhone ,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Telefon Numaranız",
                        hintText: "Tel No",
                        border:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green,width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  MyButton(
                    buttonIcon: Icon(Icons.save,color: Colors.black,),
                    onPressed:() {
                      _userdataUpdate(context);
                      _fotoUpload(context);
                    },
                    buttonColor: Colors.blueAccent,
                    buttonText:"Değişiklikleri Kaydet",
                    textColor: Colors.black,
                  ),
                  MyButton(
                    buttonIcon: Icon(Icons.vpn_key,color: Colors.black,),
                    onPressed:_changePassword,
                    buttonColor: Colors.blueAccent,
                    buttonText:"Şifre Değiştir",
                    textColor: Colors.black,
                  ),
                ],
              ),
        ),
      )
    );

  }

  void _userdataUpdate(BuildContext context) async{
    TextEditingController _passwordControl=new TextEditingController();
    final _userModel=Provider.of<UserModel>(context,listen: false);
     var updateResult=await _userModel.updateUserData(_userModel.user.userID, _controlName.text,  _controlLastName.text,  _controlPhone.text,_controlUserName.text);
     if(updateResult==true){
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
       showModalBottomSheet(isScrollControlled:true,context: context,builder:(context){
         return Container(
           height: MediaQuery.of(context).size.height-50,
            color: Colors.blue,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Giriş Yap',style: TextStyle(fontSize: 25,color: Colors.white),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: FlatButton(
                          child: Icon(Icons.close,size: 25,color: Colors.black,),
                          onPressed:(){
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailUpdateControl,
                    decoration: InputDecoration(
                      labelText: "Eski E-Mail",
                      hintText: "E-Mail",
                      border:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,width: 5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordControl,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      hintText: "Şifre",
                      border:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,width: 5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                MyButton(
                  buttonIcon: Icon(Icons.change_history,color: Colors.black,),
                  onPressed:() async{
                    if(_emailUpdateControl.text.isNotEmpty && _passwordControl.text.isNotEmpty){
                      bool updateResult = await _userModel.updateEmail(_emailUpdateControl.text,_controlEmail.text,_passwordControl.text, _userModel.user.userID);
                      if(updateResult==true){
                        AlertDialogWidget(
                          baslik: "Değişiklikler Kaydedildi",
                          icerik: "Mail Adresini Güncellendi, Kullanmaya Başlayabilirsiniz.",
                          buttonText: "Tamam",
                        ).show(context);
                      }else{
                        AlertDialogWidget(
                          baslik: "Değişiklik Olmadı",
                          icerik: "Mail Adresiniz Güncellenirken Hata Oluştu! Bilgilerinizi Kontrol Ediniz veya Farklı Bir Mail Adresi Deneyiniz",
                          buttonText: "Tamam",
                        ).show(context);
                      }
                    }else{
                      AlertDialogWidget(
                        baslik: "Hata !",
                        icerik: "Alanlar Boş Geçilemez",
                        buttonText: "Tamam",
                      ).show(context);
                    }
                  },
                  buttonColor: Colors.yellow,
                  buttonText:"Değiştir",
                  textColor: Colors.black,
                ),
              ],
            ),
         );
       });
     }
  }
  void _changePassword(){
    TextEditingController _passwordControl=new TextEditingController();
    TextEditingController _newPasswordControl=new TextEditingController();
    final _userModel=Provider.of<UserModel>(context,listen: false);
    showModalBottomSheet(isScrollControlled:true,context: context,builder:(context){
      return Container(
        height: MediaQuery.of(context).size.height-50,
        color: Colors.blue,
        child: Column(
          children: [
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Giriş Yap',style: TextStyle(fontSize: 25,color: Colors.white),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: FlatButton(
                      child: Icon(Icons.close,size: 25,color: Colors.black,),
                      onPressed:(){
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailUpdateControl,
                decoration: InputDecoration(
                  labelText: "E-Mail",
                  hintText: "E-Mail",
                  border:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: _passwordControl,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  hintText: "Şifre",
                  border:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _newPasswordControl,
                decoration: InputDecoration(
                  labelText: "Yeni Şifre",
                  hintText: "Yeni Şifre",
                  border:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            MyButton(
              buttonIcon: Icon(Icons.vpn_key_rounded,color: Colors.black,),
              onPressed:() async{
                if(_emailUpdateControl.text.isNotEmpty && _passwordControl.text.isNotEmpty && _newPasswordControl.text.isNotEmpty){
                  bool updateResult = await _userModel.updatePassword(_emailUpdateControl.text, _passwordControl.text, _newPasswordControl.text);
                  if(updateResult==true){
                    AlertDialogWidget(
                      baslik: "İşlem Başarılı",
                      icerik: "Şire Başarılı Bir Şekilde Güncellendi Bir Sonraki Girişinizde Kullanmaya Başlayabilirsiniz.",
                      buttonText: "Tamam",
                    ).show(context);
                  }else{
                    AlertDialogWidget(
                      baslik: "Değişiklik Olmadı",
                      icerik: "Şifre Güncellenirken Hata Oluştu! Bilgilerinizi Kontrol Ediniz.",
                      buttonText: "Tamam",
                    ).show(context);
                  }
                }else{
                  AlertDialogWidget(
                    baslik: "Hata !",
                    icerik: "Alanlar Boş Geçilemez",
                    buttonText: "Tamam",
                  ).show(context);
                }
              },
              buttonColor: Colors.yellow,
              buttonText:"Değiştir",
              textColor: Colors.black,
            ),
          ],
        ),
      );
    });
}
}

class CurvePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color= Color(0xff2e7c9a);
    paint.style= PaintingStyle.fill;

    Path path=Path();
    path.moveTo(0, 0);
    path.lineTo(0,size.height);
    path.quadraticBezierTo(size.width*0.2, size.height+110, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}




