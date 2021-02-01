import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytaxi/model/message_model.dart';
import 'package:mytaxi/model/user_model.dart';
import 'package:mytaxi/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  @override
  final MyUser currentUser;
  final MyUser secondUser;

   Chat({this.currentUser, this.secondUser});
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  var _messageController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userModel=Provider.of<UserModel>(context);
    MyUser _currentUser=widget.currentUser;
    MyUser _secondUser=widget.secondUser;

    ScrollController _scrollController= new ScrollController();

    return Scaffold(
      appBar: AppBar(title: Text(_secondUser.userName),
      ),
      body: Center(
        child: Column(
          children: [
           Expanded(child: StreamBuilder<List<Message>>(
             stream: _userModel.getMessages(_currentUser.userID,_secondUser.userID),
             builder: (context,streamMessageList){

               if(!streamMessageList.hasData){
                 return Center(child: CircularProgressIndicator(),);
               }
               var allMessages=streamMessageList.data;
               return ListView.builder(
                 controller: _scrollController,
                 reverse: true,
                 itemBuilder:(context,index){
                 return _createChatArea(allMessages[index]);
               },itemCount: allMessages.length,) ;
             },
           ),
           ),
          Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8,left: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    cursorColor: Colors.blueGrey,
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Mesajiniz',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor:Colors.blue,
                    child: Icon(
                      Icons.navigation,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () async{
                      if(_messageController.text.trim().length>0){
                        Message _saveMessage=Message(
                          fromWho: _currentUser.userID,
                          toWho: _secondUser.userID,
                          toWho_name: _secondUser.userName,
                          toWho_profileURL: _secondUser.profileURL,
                          fromMe: true,
                          message: _messageController.text,
                        );
                        var sonuc= await _userModel.saveMessage(_saveMessage);
                        if(sonuc){
                          _messageController.clear();
                          _scrollController.animateTo(
                            0,
                            curve:Curves.easeOut,
                            duration:const Duration(microseconds: 10),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          ),

          ],
        )
      ),
    );
  }

  Widget _createChatArea(Message indexMessage) {
    Color _gelenMesajColor=Colors.deepPurpleAccent;
    Color _gidenMesajColor= Theme.of(context).primaryColor;
   var _timeValue= '';
   try{
      _timeValue= _showTime(indexMessage.date?? Timestamp(1,1));
   }catch(e){
        print('error: '+e.toString());
   }
    var _messageFromMe=indexMessage.fromMe;
    if(_messageFromMe){
      return Padding(padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _gidenMesajColor,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(4),
                  child: Text(indexMessage.message,style: TextStyle(color: Colors.white),),
                ),
              ),
              Text(_timeValue),
            ],
          ),
        ],
      ),
      );

    }else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.secondUser.profileURL),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(indexMessage.message),
                  ),
                ),
                Text(_timeValue),
              ],
            )

          ],
        ),
      );

    }

  }

  String _showTime(Timestamp date) {
    var _formatter=DateFormat.Hm();
    var _formatTime=_formatter.format(date.toDate());
    return _formatTime;

  }
}
