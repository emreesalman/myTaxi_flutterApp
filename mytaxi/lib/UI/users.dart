import 'package:flutter/material.dart';
import 'package:mytaxi/UI/chat.dart';
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
      appBar: AppBar(
          title:Text('Kullanicilar'),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controlString ,
                    decoration: InputDecoration(
                      labelText: "Aranacak Kullanici",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text("Ara"),
                  onPressed:() {
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
                                          MaterialPageRoute(builder: (context)=>Chat(currentUser: _userModel.user,secondUser:indexUser,),
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
                    },
                ),
              ],
            ),
          ),
        ),
    );
  }
}
