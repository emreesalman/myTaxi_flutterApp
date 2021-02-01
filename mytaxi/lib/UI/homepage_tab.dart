import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytaxi/UI/addpost.dart';
import 'package:mytaxi/UI/dm.dart';
import 'package:mytaxi/UI/my_posts.dart';
import 'package:mytaxi/UI/profile.dart';
import 'package:mytaxi/UI/searchpost.dart';
import 'package:mytaxi/UI/update.dart';
import 'package:mytaxi/UI/users.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';


class HomePageTab extends StatefulWidget {
  @override
  _HomePageTabState createState() => _HomePageTabState();
}

class _HomePageTabState extends State<HomePageTab> {
  @override
  Widget build(BuildContext context) {
    final _userModel =Provider.of<UserModel>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: new AppBar(
        title: Text("MYTAXI"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Users())),
              child: Icon(Icons.search_off_outlined,size: 26,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => DMBox())),
              child: Icon(Icons.messenger_outline,size: 26,),
            ),
          ),
        ],
      ),
      body:SafeArea(
        child: Container(
          child: Stack(
            children:<Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  painter: CurvePainter(),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50,top: 100),
                child: Text('Hemen',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.w300),),
              ),
              Container(
                padding: EdgeInsets.only(left: 92,top: 150),
                child: Text('Başla',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.w300),),
              ),
              Container(
                padding: EdgeInsets.only(left: 209,top: 117),
                child: Text('.',style: TextStyle(fontSize: 90,color: Colors.purple,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:210),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 110,right: 5,left: 5),
                        child: GestureDetector(
                          onTap:()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => addPostView()),
                          ),
                          child: Container(
                            height: 150,
                            width: 120,

                            child: Stack(
                              children:<Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Icon(Icons.directions_car,size: 100,color: Colors.brown,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50,top: 5),
                                  child: Icon(Icons.add,size: 50,color: Colors.deepOrange,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 21,top:100),
                                  child: Text('Ilan Ver',style: TextStyle(color: Colors.black,fontSize: 18),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 110,right: 5,left: 5),
                        child: GestureDetector(
                          onTap:()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => searchPostView()),
                          ),
                          child: Container(
                            height: 150,
                            width: 120,
                            child: Stack(
                              children:<Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Icon(Icons.directions_car,size: 100,color: Colors.purple,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50,top: 5),
                                  child: Icon(Icons.search,size: 50,color: Colors.deepOrange,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20,top:100),
                                  child: Text('Ilan Ara',style: TextStyle(color: Colors.black,fontSize: 18),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: new Drawer(
        child: Container(
          color: Color(0xff2e7c9a),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff2e7c9a),
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    verticalDirection: VerticalDirection.down,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        elevation: 10,
                        child: Padding(padding: EdgeInsets.all(0.0),
                          child: CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.white,
                            backgroundImage:NetworkImage(_userModel.user.profileURL),
                            ),
                          ),

                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 11),
                        child: Text(_userModel.user.name.toString()+" "+_userModel.user.lastName.toString(),style: TextStyle(color:Colors.white,fontSize: 18),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 17,top: 5),
                        child: Text(_userModel.user.userName.toString(),style: TextStyle(color: Colors.white,fontSize: 15),),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: ()=> Navigator.of(context,rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => profileView()),
                ),
                leading: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: Icon(Icons.supervised_user_circle,size: 30,color: Colors.black,),
                ),
                title: Text("Profil"),

              ),
              ListTile(
                onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => searchPostView()),
                ),
                leading: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: Icon(Icons.image_search,size: 30,color: Colors.black,),
                ),
                title: Text("Ilan Ara"),
              ),
              ListTile(
                onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addPostView()),
                ),
                leading: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: Icon(Icons.image_outlined,size: 30,color: Colors.black,),
                ),
                title: Text("Ilan Ver"),
              ),
              ListTile(
                onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPosts()),
                ),
                leading: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: Icon(Icons.list_alt,size: 30,color: Colors.black,),
                ),
                title: Text("Katildigim Ilanlar"),
              ),
              ListTile(
                //onTap:() ,
                leading: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: Icon(Icons.exit_to_app_outlined,size: 30,color: Colors.black,),
                ),
                title: Text("Çıkış Yap"),
                onTap: ()=>_signOutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _signOut(BuildContext context)async{
    final _userModel =Provider.of<UserModel>(context, listen: false);
    bool sonuc=await _userModel.signOut();
    return sonuc;
  }

  Future _signOutDialog(BuildContext context) async{
    final sonuc =await AlertDialogWidget(baslik:"Cikisi Onayla",icerik: "Cikmak istediginize emin misiniz?",buttonText: "Onayla").show(context);
    if(sonuc==true){
      _signOut(context);
    }
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


