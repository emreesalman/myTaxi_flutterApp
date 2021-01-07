import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mytaxi/model/post_model.dart';

class addPostView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddPostState();
  }
}
class AddPostState extends State<addPostView>{

  int _kisiSayisi;
  String _tarih,_saat;



  @override
  Widget build(BuildContext context) {
    DateTime bitis=DateTime(2021,1,DateTime.now().month+1);

    return Scaffold(
      appBar: AppBar(title: Text("Ilan Ekle"),),
      body: Padding(padding: EdgeInsets.all(20),
      child: Form(
        child: ListView(
          children: <Widget>[
            Text("Baslangic Konum"),
            Text("Bitis Konum"),
            Text("Kisi Sayisi Seciniz:"),
            DropdownButton<int>(items: [
              DropdownMenuItem<int>(child: Text("1"),value: 1,),
              DropdownMenuItem<int>(child: Text("2"),value: 2,),
              DropdownMenuItem<int>(child: Text("3"),value: 3,),
            ],onChanged: (int Secilen){
              setState(() {
                _kisiSayisi=Secilen;
              });
            },
            hint: Text("Seciniz"),
              value: _kisiSayisi,
            ),
            RaisedButton(
              child: Text("Tarih Sec"),
              onPressed: (){
                showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime.now(), lastDate: bitis).then((value){
                  debugPrint(value.toString());
                  //Burada atama islemi yapilacak
                 setState(() {
                   _tarih=formatDate(value,[dd,'-',mm,'-',yyyy]).toString();
                 });
                });
              },
            ),
            Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text(_tarih.toString()),
              ),
            ),
            RaisedButton(
              child: Text("Saat Sec"),
              onPressed:() {
                showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
                  debugPrint(value.format(context));
                  debugPrint(value.hour.toString()+':'+value.minute.toString());
                  setState(() {
                    _saat=value.hour.toString()+':'+value.minute.toString();
                  });
                });
              },
            ),
            Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text(_saat.toString()),
              ),
            ),
            RaisedButton(
              child: Text("Ilani Ekle"),
              onPressed: _addPost,
            )
          ],
        ),
      ),
      ),
    );
  }
  void _addPost()async{
    final _userModel=Provider.of<UserModel>(context,listen: false);
    MyUser _user= await _userModel.currentUser();
    String _userID= _user.userID;
    String _starLocation='Bahcesehir';
    String _endLocation='avcilar';
      MyPost _post = MyPost(userName: _userModel.user.userName,userID: _userID, startLocation: _starLocation,
          endLocation: _endLocation, date: _tarih,
          time: _saat, peopleCount: _kisiSayisi,userProfileURL: _userModel.user.profileURL);
      bool sonuc= await _userModel.savePost(_post);
      if(sonuc){
        AlertDialogWidget(
          baslik: 'Ilan Basarili',
          icerik: 'Ilan basariyla yayinlandi',
          buttonText: 'Tamam',
        ).show(context);
      }
  }
}