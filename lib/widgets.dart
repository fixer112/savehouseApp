import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'values.dart';

class Widgets {

  static textField( controller, hintText, type ){
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: whiteColor,
          filled: true,
          border: OutlineInputBorder( borderSide: BorderSide.none ),
          hintText: hintText,
          hintStyle: TextStyle( fontFamily: 'FB Agency', color: Colors.black, fontWeight: FontWeight.bold )
        ),
        obscureText: type==TextInputType.visiblePassword ? true : false,
        keyboardType: type
      ),
    );
  }

  static pageTitle( mainText, supportText, { icon = true } ){
    return Container(
      margin: EdgeInsets.only( top: 50 ),
      child: Row(children: <Widget>[
        Column(
          children: <Widget>[
            Text( mainText, style: TextStyle( fontSize: 27.0, fontWeight: FontWeight.w900, fontFamily: 'Corbel' ),),
            SizedBox(height: 4),
            Text( supportText, style: TextStyle( fontSize: 13, fontWeight: FontWeight.w600 ), ),
          ],
        ),
        icon==false ? Container() : IconButton(
          icon: Icon( Icons.account_circle, color: primaryColor, size: 37, ),
          onPressed: (){

          },
        ),
      ], mainAxisAlignment: MainAxisAlignment.spaceBetween,)
    );
  }

  static bottomNav( index ){
    return BottomNavigationBar(
      currentIndex: index,
      fixedColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.account_circle, color: ( index==0 ? primaryColor : Colors.grey ), ),
          title: Text( 'Account', style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold ), ),
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.home, color: ( index==1 ? primaryColor : Colors.grey ), ),
          title: Text( 'Home', style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold ), ),
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.satellite, color: ( index==2 ? primaryColor : Colors.grey ), ),
          title: Text( 'Invest', style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold ), ),
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.note, color: ( index==3 ? primaryColor : Colors.grey ), ),
          title: Text( 'Activity', style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold ), ),
        ),
      ],
    );
  }

  static textShadows(){
    return <Shadow>[
      Shadow( color: Colors.black, offset: Offset( 1, 1 ), blurRadius: .4 ),
      Shadow( color: Colors.black, offset: Offset( 1, -1 ), blurRadius: .4 ),
      Shadow( color: Colors.black, offset: Offset( -1, 1 ), blurRadius: .4 ),
      Shadow( color: Colors.black, offset: Offset( -1, -1 ), blurRadius: .4 ),
    ];
  }

}