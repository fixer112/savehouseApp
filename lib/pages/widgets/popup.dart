import 'package:flutter/material.dart';

class PopUp extends StatefulWidget {
  
  final Icon icon;
  final String strongText;
  final String text;
  final Function callback;

  PopUp(this.icon, this.strongText, this.text, {this.callback, Key key}) : super(key: key);

  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Stack(
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            top: 0,
            left: 0,
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: (){
                if( widget.callback!=null ){
                  widget.callback();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height-320)/2,
            height: 320,
            left: 35,
            right: 35,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10),
                  widget.icon,
                  SizedBox(height: 35.0),
                  Text( widget.strongText, style: TextStyle( fontSize: 27.0, fontWeight: FontWeight.bold, fontFamily: 'calibri' ), textAlign: TextAlign.center, ),
                  SizedBox(height: 15),
                  Text( widget.text, style: TextStyle( fontSize: 15, ), textAlign: TextAlign.center, ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showPopUp( context, icon, strongText, text, callback ){
  showDialog(
    context: context,
    builder: (BuildContext context) => PopUp( icon, strongText, text, callback: callback, ),
  );
}

void showSuccessPopUp( context, text, callback ){
  showPopUp(context, Icon( Icons.check_circle, color: Colors.redAccent, size: 80 ), 'Hooray', text, callback);
}