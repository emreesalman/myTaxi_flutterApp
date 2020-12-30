import 'package:flutter/material.dart';
import 'package:mytaxi/model/dm_model.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

import 'chat.dart';

class DMBox extends StatefulWidget {
  @override
  _DMBoxState createState() => _DMBoxState();
}

class _DMBoxState extends State<DMBox> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel=Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Sohbetlerim"),),
      body:FutureBuilder<List<MyChat>>(
        future: _userModel.getAllFriend(_userModel.user.userID),
        builder: (context, friendList){
          if(!friendList.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else{
            var allFriend=friendList.data;
            if(allFriend.length>0){
              return RefreshIndicator(
                onRefresh: _refreshList,
                child: Padding(padding: EdgeInsets.only(bottom: 5),
                  child:  ListView.builder(itemBuilder:(context,index){
                    var indexFriend=allFriend[index];
                    return Card(
                      elevation: 8,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) =>
                                Chat(currentUser: _userModel.user,
                                  secondUser: MyUser.data(
                                      userID: indexFriend.second_user,
                                      userName: indexFriend.secondUser_name,
                                      profileURL: indexFriend
                                          .secondUser_profileURL),),
                            ),
                          );
                        },
                        title: Text(indexFriend.secondUser_name),
                        subtitle: Text(indexFriend.last_message),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(indexFriend.secondUser_profileURL),
                        ),
                      ),
                    );
                  } ,itemCount: allFriend.length,),
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
                          Icon(Icons.chat,color: Theme.of(context).primaryColor,
                              size: 100,
                          ),
                          Text('Bir Konusma Baslat',textAlign:TextAlign.center,style: TextStyle(fontSize: 25),),
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
