import 'package:flutter/material.dart';
import 'package:mytaxi/UI/chat.dart';
import 'package:mytaxi/app/raised_button.dart';
import 'package:mytaxi/model/post_model.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';


class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel=Provider.of<UserModel>(context);
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(title: Text('Aktif Ilanlar'),),
      body:FutureBuilder<List<MyPost>>(
            future: _userModel.userPosts(_userModel.user.userID),
            builder: (context, userPostList){
              if(!userPostList.hasData){
                return Center(child: CircularProgressIndicator(),);
              }else{
                var allPosts=userPostList.data;
                if(allPosts.length>0){
                  return RefreshIndicator(
                    onRefresh: _refreshList,
                    child: Padding(padding: EdgeInsets.only(bottom: 5),
                      child:  ListView.builder(itemBuilder:(context,index){
                        return Stack(
                          children:<Widget>[
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
                                              backgroundImage: NetworkImage(allPosts[index].userProfileURL),
                                            ),
                                            Expanded(
                                              child: Text(allPosts[index].userName.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 70),
                                                  child: Icon(Icons.watch_later_outlined,color: Colors.black,),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(left:2),
                                                    child: Text(allPosts[index].time.toString(),style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),)
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.location_on,color: Colors.green,size: 25,),
                                            Flexible(child: Text(allPosts[index].starAdress.toString())),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:Row(
                                          children: [
                                            Icon(Icons.location_on,color: Colors.red,size: 25,),
                                            Flexible(child: Text(allPosts[index].endAdress.toString())),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ExpansionTile(
                                          title: Text(allPosts[index].postTitle.toString()),
                                          children: [
                                            Text('Kisi Sayisi: '+allPosts[index].peopleCount.toString()),

                                            Padding(
                                              padding: const EdgeInsets.only(left: 7,top: 4,bottom: 8),
                                              child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(allPosts[index].postMessage.toString())),
                                            ),

                                            Wrap(
                                              children: [
                                                MyButton(
                                                  textColor: Colors.black,
                                                  buttonColor: Colors.yellow,
                                                  onPressed: (){},
                                                  buttonIcon: Icon(Icons.map),
                                                  buttonText: "Konuma Bak",
                                                ),
                                                _userModel.user.userID!=allPosts[index].userID?MyButton(
                                                  textColor: Colors.black,
                                                  buttonColor: Colors.yellow,
                                                  onPressed: (){
                                                    Navigator.of(context,rootNavigator: true).push(
                                                      MaterialPageRoute(builder: (context)=>Chat(currentUser: _userModel.user,secondUser:MyUser.data(
                                                          userID: allPosts[index].userID, userName:allPosts[index].userName,
                                                          profileURL:allPosts[index].userProfileURL)),
                                                      ),
                                                    );
                                                  },
                                                  buttonIcon: Icon(Icons.message),
                                                  buttonText: "Mesaj Gönder",
                                                ): MyButton(
                                                  textColor: Colors.black,
                                                  buttonColor: Colors.yellow,
                                                  onPressed: (){},
                                                  buttonIcon: Icon(Icons.cancel),
                                                  buttonText: "Ilanı Sil",
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
                      } ,itemCount: allPosts.length,),
                    ),
                  );
                }else{
                  return RefreshIndicator(
                    onRefresh: _refreshList,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.post_add,color: Theme.of(context).primaryColor,
                                size: 100,
                              ),
                              Text('Aktif Bir Ilan Yok',textAlign:TextAlign.center,style: TextStyle(fontSize: 25),),
                            ],
                          ),
                        ),
                        height: MediaQuery.of(context).size.height-150,
                      ),
                    ),
                  );
                }
              }
            },
          ),
    );
  }
  Future<Null> _refreshList() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() { });
    return null;
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