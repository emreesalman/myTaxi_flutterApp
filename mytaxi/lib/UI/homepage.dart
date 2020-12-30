import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytaxi/UI/addpost.dart';
import 'package:mytaxi/UI/profile.dart';
import 'package:mytaxi/UI/searchpost.dart';
import 'package:mytaxi/UI/update.dart';
import 'package:mytaxi/UI/users.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

import 'dm.dart';

class homePageView extends StatelessWidget{
   final user;
   homePageView({Key key,@required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: new AppBar(
      title: Text("myTaxi"),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Users())),
            child: Icon(Icons.search_off_outlined,size: 26,),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => DMBox())),
            child: Icon(Icons.message_outlined,size: 26,),
          ),
        ),
      ],
    ),
     body: SingleChildScrollView(

            child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.amber,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => addPostView()),
                                );
                              },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 100.0),
                              alignment: Alignment.bottomCenter,
                              height: 115.0,
                              width: 125.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/icons/icon_addButton.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Transform(
                                alignment: Alignment.bottomCenter,
                                transform: Matrix4.skewY(0.0)..rotateZ(0.0),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  color: Color(0xFFFFFFFF),
                                  child: new Text("Ilan Ver",textDirection: TextDirection.ltr,textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap:()=>Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => searchPostView()),
                            ),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 100.0),
                              alignment: Alignment.bottomCenter,
                              height: 115.0,
                              width: 125.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/icons/icon_searchButton.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Transform(
                                alignment: Alignment.bottomCenter,
                                transform: Matrix4.skewY(0.0)..rotateZ(0.0),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  color: Color(0xFFFFFFFF),
                                  child: new Text("Ilan Ara",textDirection: TextDirection.ltr,textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
     ),
     drawer: new Drawer(
       child: ListView(
         padding: EdgeInsets.zero,
         children: <Widget>[
           DrawerHeader(
             decoration: BoxDecoration(

             ),
             child: Container(
               child: Column(
                 children: <Widget>[
                   Material(
                     borderRadius: BorderRadius.all(Radius.circular(50.0)),
                     elevation: 10,
                   )
                 ],
               ),
             ),
           ),
           ListTile(
             onTap: ()=> Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => profileView()),
             ),
           leading: SizedBox(
           height: 40.0,
            width: 40.0,
           ),
            title: Text("Profile"),
           ),
           ListTile(
             onTap: ()=> Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => searchPostView()),
             ),
             leading: SizedBox(
               height: 40.0,
               width: 40.0,
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
             ),
             title: Text("Ilan Ver"),
           ),
           ListTile(
             onTap: ()=> Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => updateView()),
             ),
             leading: SizedBox(
               height: 40.0,
               width: 40.0,
             ),
             title: Text("UPDATE"),
           ),
           ListTile(
             onTap: ()=> Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => Users()),
             ),
             leading: SizedBox(
               height: 40.0,
               width: 40.0,
             ),
             title: Text("Duraklar"),
           ),
           ListTile(
             //onTap:() ,
             leading: SizedBox(
               height: 40.0,
               width: 40.0,
             ),
             title: Text("CIKIS"),
             onTap: ()=>_signOutDialog(context),
           ),
         ],
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
