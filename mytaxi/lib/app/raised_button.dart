import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const MyButton({Key key, this.buttonText, this.buttonColor, this.textColor, this.buttonIcon, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15),
      child: RaisedButton(

        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buttonIcon,
            Text(buttonText,style: TextStyle(color: textColor,fontSize: 16),),
            Opacity(opacity:0,child: buttonIcon),
          ],
        ),
        color: buttonColor,

      ),
    );
  }
}
