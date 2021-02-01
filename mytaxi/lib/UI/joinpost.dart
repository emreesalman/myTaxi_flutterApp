import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytaxi/app/alert_widget.dart';
import 'package:mytaxi/app/raised_button.dart';
import 'package:mytaxi/model/post_model.dart';
import 'package:mytaxi/UI/chat.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class JoinPost extends StatefulWidget {
  List<MyPost> myPosts;
  String date;
  JoinPost({Key key, @required this.myPosts,this.date}):super(key: key);
  @override
  _JoinPostState createState() => _JoinPostState(myPosts,date);
}

class _JoinPostState extends State<JoinPost> {
  List<MyPost> myPosts;
  String date;
  _JoinPostState(this.myPosts,this.date);
  @override
  Widget build(BuildContext context) {
    UserModel _userModel=Provider.of<UserModel>(context,listen: false);

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(title: Text(date.toString()),
      ),
      body:myPosts.length>0? ListView.builder(
          itemCount: myPosts.length,
          itemBuilder: (context, index){
            return Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width,
                  child: CustomPaint(
                    painter: CurvePainter(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Color(0xff2e7c9a),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.only(topLeft:Radius.zero,topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(50))
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25,top: 9),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(myPosts[index].userProfileURL),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(myPosts[index].userName.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 70),
                                  child: Icon(Icons.watch_later_outlined,color: Colors.black,),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left:2),
                                    child: Text(myPosts[index].time.toString(),style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),)
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.green,size: 25,),
                                Flexible(child: Text(myPosts[index].starAdress.toString())),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.red,size: 25,),
                                Flexible(child: Text(myPosts[index].endAdress.toString())),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                              title: Text(myPosts[index].postTitle.toString()),
                              children: [
                                 Text('Kisi Sayisi: '+myPosts[index].peopleCount.toString()),

                                 Padding(
                                   padding: const EdgeInsets.only(left: 7,top: 4,bottom: 8),
                                   child: Container(
                                       alignment: Alignment.centerLeft,
                                       child: Text(myPosts[index].postMessage.toString())),
                                 ),

                                Wrap(
                                  children: [
                                    MyButton(
                                      buttonText:"Katıl",
                                      textColor: Colors.black,
                                      buttonColor: Colors.yellow,
                                      onPressed: () async {
                                        try {
                                          MyUser _user = await _userModel
                                              .currentUser();
                                          bool sonuc = await _userModel.joinPost(
                                              _user.userID, _user.userName,
                                              _user.profileURL,
                                              myPosts[index].postID);
                                          if (sonuc) {
                                            AlertDialogWidget(
                                              baslik: 'Islem Basarili',
                                              icerik: 'Ilana Katildiniz',
                                              buttonText: 'Tamam',
                                            ).show(context);
                                          } else {
                                            AlertDialogWidget(
                                              baslik: 'Islem Basarsiz',
                                              icerik: 'Ayni Ilana Tekrar Katilamazsiniz',
                                              buttonText: 'Tamam',
                                            ).show(context);
                                          }
                                        } catch (e) {
                                          AlertDialogWidget(
                                            baslik: 'Islem Basarsiz',
                                            icerik: e.toString(),
                                            buttonText: 'Tamam',
                                          ).show(context);
                                        }
                                      },
                                      buttonIcon: Icon(Icons.arrow_right_alt),
                                    ),
                                      MyButton(
                                        textColor: Colors.black,
                                        buttonColor: Colors.yellow,
                                        onPressed: (){},
                                        buttonIcon: Icon(Icons.map),
                                        buttonText: "Konuma Bak",
                                      ),
                                    MyButton(
                                      textColor: Colors.black,
                                      buttonColor: Colors.yellow,
                                      onPressed: (){
                                        Navigator.of(context,rootNavigator: true).push(
                                          MaterialPageRoute(builder: (context)=>Chat(currentUser: _userModel.user,secondUser:MyUser.data(
                                              userID: myPosts[index].userID, userName:myPosts[index].userName,
                                              profileURL:myPosts[index].userProfileURL)),
                                          ),
                                        );
                                      },
                                      buttonIcon: Icon(Icons.message),
                                      buttonText: "Mesaj Gönder",
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }):
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date.toString(),style: TextStyle(fontSize: 23,color: Colors.blue),),
                Text("Kriterlere Uygun İlan Bulunamadı",style: TextStyle(fontSize: 23),),
              ],
            ),
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