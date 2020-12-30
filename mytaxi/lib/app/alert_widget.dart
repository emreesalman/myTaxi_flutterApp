
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget{
  final String baslik;
  final String icerik;
  final String buttonText;
  const AlertDialogWidget({Key key, @required this.baslik, @required this.icerik, @required this.buttonText}) : super(key: key);

  Future<bool> show(BuildContext context)async{
    return await showDialog<bool>(context:context,builder: (context)=>this);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(baslik),
          Expanded(
              child: FlatButton(
                child: Icon(Icons.close),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
        ],
      ),
      content: Text(icerik),
      actions: <Widget>[
            FlatButton(
              child: Text(buttonText,),
              onPressed: (){
                Navigator.of(context).pop(true);
              },
            ),
      ],
    );
  }

}
