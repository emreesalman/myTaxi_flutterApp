


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/raised_button.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mytaxi/model/post_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mytaxi/UI/map.dart';
import 'package:geocoder/geocoder.dart' as geoCo;


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
  double _startLocationLat;
  double _startLocationLong;
  double _endLocationLat;
  double _endLocationLong;
  String _startAdress,_endAdress;

  TextEditingController _titleControl=new TextEditingController();
  TextEditingController _contentControl=new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleControl=TextEditingController();
    _contentControl=TextEditingController();
  }

  @override
  void dispose() {
    _titleControl.dispose();
    _contentControl.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    DateTime bitis=DateTime(2021,2,DateTime.now().month+1);
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(title: Text("İlan Ekle"),),
      body: Stack(
        children:<Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Padding(padding: EdgeInsets.all(20),
          child: Form(
            child: ListView(
              children: <Widget>[
                          GestureDetector(
                            onTap:()=>Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) => Map()),
                            ).then((value){
                              setState(()  {
                                LatLng temp=value;
                                _startLocationLat=temp.latitude;
                                _startLocationLong=temp.longitude;
                                getStartAdress(_startLocationLat, _startLocationLong);
                                print(_startAdress.toString());
                              });
                            }),
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width-45,
                              child: Center(child: Text(_startAdress !=null?_startAdress.toString():"Başlangıç Konumunu Seçiniz",textAlign: TextAlign.center,)),
                              decoration: BoxDecoration(
                                color:Color(0xff2e7c9a),
                                border:Border.all(color: Colors.grey,width: 1),
                                borderRadius: BorderRadius.circular(16)
                              ),
                            ),
                          ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap:()=> Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) => Map()),
                  ).then((value){
                    setState(() {
                      LatLng temp=value;
                      _endLocationLat=temp.latitude;
                      _endLocationLong=temp.longitude;
                      getEndAdress(_endLocationLat,_endLocationLong);
                      print(_endAdress.toString());

                    });
                  }),
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width-45,
                    child: Center(child: Text(_endAdress !=null?_endAdress.toString():"Bitiş Konumunu Seçiniz",textAlign: TextAlign.center,)),
                    decoration: BoxDecoration(
                        color:Color(0xff2e7c9a),
                        border:Border.all(color: Colors.grey,width: 1),
                        borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                DropdownButton<int>(items: [
                  DropdownMenuItem<int>(child: Text("1"),value: 1,),
                  DropdownMenuItem<int>(child: Text("2"),value: 2,),
                  DropdownMenuItem<int>(child: Text("3"),value: 3,),
                ],onChanged: (int value){
                  setState(() {
                    _kisiSayisi=value;
                  });
                },
                hint: Text("Kisi Sayisi Seciniz:",textAlign: TextAlign.center,),
                  value: _kisiSayisi,
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: _titleControl ,
                  decoration: InputDecoration(
                    labelText: "İlan Başlığı",
                    hintText: "İlan Başlığı Giriniz",
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
                SizedBox(height: 15,),
                TextFormField(
                  controller: _contentControl ,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "İlan İçeriği",
                    hintText: "İlan Başlığı Giriniz",
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
                SizedBox(height: 15,),
                Row(
                  children: [
                    MyButton(buttonText:_tarih!=null?_tarih.toString():"Tarih Seç",
                      textColor: Colors.black,
                      buttonColor: Colors.lightBlueAccent,
                      onPressed: (){
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime.now(), lastDate: bitis).then((value){
                          debugPrint(value.toString());
                          setState(() {
                            _tarih=formatDate(value,[dd,'-',mm,'-',yyyy]).toString();
                          });
                        });
                      },
                      buttonIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    MyButton(buttonText:_saat!=null?_saat.toString():"Saat Seç",
                      textColor: Colors.black,
                      buttonColor: Colors.lightBlueAccent,
                      onPressed:() {
                        showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
                          debugPrint(value.format(context));
                          debugPrint(value.hour.toString()+':'+value.minute.toString());
                          setState(() {
                            _saat=value.hour.toString()+':'+value.minute.toString();
                          });
                        });
                      },
                      buttonIcon: Icon(Icons.watch_later_outlined),
                    ),
                  ],
                ),
                SizedBox(height: 22,),
                MyButton(buttonText:"İlanı Yayınla",
                  textColor: Colors.black,
                  buttonColor: Colors.lightBlueAccent,
                  onPressed:_addPost,
                  buttonIcon: Icon(Icons.add_photo_alternate_outlined),
                ),

              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
  void _addPost()async{
    final _userModel=Provider.of<UserModel>(context,listen: false);
    MyUser _user= await _userModel.currentUser();
    String _userID= _user.userID;
    try{
      MyPost _post = MyPost(userName: _userModel.user.userName,userID: _userID, startLocationLat:_startLocationLat,
          starAdress: _startAdress.toString(),endAdress: _endAdress.toString(),
          startLocationLong:_startLocationLong,
          postTitle: _titleControl.text,postMessage: _contentControl.text,
          endLocationLat: _endLocationLat,endLocationLong: _endLocationLong, date: _tarih,
          time: _saat, peopleCount: _kisiSayisi,userProfileURL: _userModel.user.profileURL);
      bool sonuc= await _userModel.savePost(_post);
      if(sonuc){
        AlertDialogWidget(
          baslik: 'Ilan Basarili',
          icerik: 'Ilan basariyla yayinlandi',
          buttonText: 'Tamam',
        ).show(context);
      }
    }catch(e){
      print("HATA "+e.toString());
    }
  }

  void getStartAdress(double Lat, double Long)async {
    try{
      final coordinated = new geoCo.Coordinates(Lat, Long);
      var adress= await geoCo.Geocoder.local.findAddressesFromCoordinates(coordinated);
      var firstAdress=adress.first;
      print(firstAdress.addressLine);
      print(firstAdress.countryName);
      setState(() {
        _startAdress=firstAdress.addressLine;
      });
    }on PlatformException catch(e){
      debugPrint('HATA :'+e.toString());
    }

  }
  void getEndAdress(double Lat, double Long)async {
    final coordinated = new geoCo.Coordinates(Lat, Long);
    var adress= await geoCo.Geocoder.local.findAddressesFromCoordinates(coordinated);
    var firstAdress=adress.first;
    print(firstAdress.addressLine);
    print(firstAdress.countryName);
    setState(() {
      _endAdress=firstAdress.addressLine;
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