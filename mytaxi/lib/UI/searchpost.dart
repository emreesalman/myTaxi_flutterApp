import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';


class searchPostView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchPostState();
  }
}
class SearchPostState extends State<searchPostView>{
  int _kisiSayisi;
  String _tarih,_saat;

  @override
  Widget build(BuildContext context) {
    DateTime baslangic=DateTime.now();
    DateTime bitis=DateTime(2021,1,DateTime.now().month+1);

    return Scaffold(
      appBar: AppBar(title: Text("Ilan Ara"),),
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
                child: Text("Ilani Ara"),
                onPressed: ()=>Navigator.pushNamed(context, "/joinpost"),
              ),
            ],
          ),
        ),
      ),
    );
  }

}