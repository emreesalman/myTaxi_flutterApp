import 'package:flutter/material.dart';
import 'package:mytaxi/UI/chat.dart';
import 'package:mytaxi/UI/show_user_profile.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/raised_button.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controlString=new TextEditingController();
    UserModel _userModel=Provider.of<UserModel>(context,listen: false);
    Future<List<MyUser>> myList;
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
          title:Text('Kullanicilar'),
      ),
      body: Stack(
        children:<Widget> [
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8,top: 15,bottom: 5),
            child: TextFormField(
              controller: _controlString ,
              decoration: InputDecoration(
                labelText: "Aranacak Kullanici",
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
            padding: const EdgeInsets.only(top: 85),
            child: MyButton(
              buttonText:'Ara',
              buttonIcon: Icon(Icons.search),
              onPressed:() {
                if(_controlString.text.isEmpty){
                  AlertDialogWidget(
                    baslik: 'Hata !',
                    icerik: 'Arama Kısmı Boş Geçilemez',
                    buttonText: 'Tamam',
                  ).show(context);
                }else{
                  showModalBottomSheet(isScrollControlled:true,context: context,builder:(context){
                    return  Container(
                      height: 500,
                      child: FutureBuilder<List<MyUser>>(
                        future: _userModel.getUser(_userModel.user.userID, _controlString.text),
                        builder: (context,sonuc){
                          if(sonuc.hasData){
                            var allUsers=sonuc.data;
                            if(allUsers.length>0){
                              return ListView.builder(
                                itemCount: allUsers.length,
                                itemBuilder: (context,index){
                                  var indexUser=sonuc.data[index];
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.of(context,rootNavigator: true).push(
                                        MaterialPageRoute(builder: (context)=>UserProfile(secondUser:indexUser,),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(indexUser.name+' '+indexUser.lastName),
                                      subtitle: Text(indexUser.userName),
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(indexUser.profileURL),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }else{
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.supervised_user_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 80,
                                  ),
                                  Text("Kayitli Kullanici Bulunamadi",
                                    style: TextStyle(fontSize: 25),)
                                ],
                              );
                            }
                          }else{
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    );
                  }
                  );
                }
              },
              buttonColor: Colors.yellow,
              textColor: Colors.black,
            ),
          ),

        ],
      ),
    );
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