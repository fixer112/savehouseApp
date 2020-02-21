import 'dart:math';

import 'package:flutter/material.dart';
import 'package:savehouse/pages/user/investment.dart';
import 'package:savehouse/pages/widgets/imagepreview.dart';
import 'package:savehouse/values.dart';
import 'package:savehouse/widgets.dart';

class Investments extends StatefulWidget {
  @override
  _InvestmentsState createState() => _InvestmentsState();
}

class _InvestmentsState extends State<Investments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(8, (index){
          return investmentEach( context );
        }),
      ),
    );
  }
}

Widget investmentEach( context ){
  return Container(
    decoration: BoxDecoration(
      border: Border.all( color: whiteColor ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: EdgeInsets.only( top: 10, bottom: 15 ),
    child: Row(
      children: <Widget>[
        InkWell(
          child: Container(
            height: 90,
            width: 90,
            child: FittedBox(
              child: FlutterLogo(colors: Colors.green,),
              fit: BoxFit.cover,
            ),
          ),
          onTap: (){
            showImagePreview(context, FlutterLogo(colors: Colors.green,));
          },
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Investment()));
          },
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text( '8omFfXp3AGG1pO1', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16 ), ),
                Container(
                  margin: EdgeInsets.only( top: 10, bottom: 0 ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text( 'N500,000', style: TextStyle( fontSize: 15 ), ),
                      SizedBox(width: 10),
                      Text( '/', style: TextStyle( fontSize: 19 ), ),
                      SizedBox(width: 10),
                      Text( '3 months', style: TextStyle( fontSize: 15 ), ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only( bottom: 10.0 ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text( '23 Mar, 2019', style: TextStyle( fontSize: 13 ), ),
                      SizedBox(width: 10),
                      Text( '-', style: TextStyle( fontSize: 19 ), ),
                      SizedBox(width: 10),
                      Text( 'not decided', style: TextStyle( fontSize: 13 ), ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text( ['Forex', 'Real Estate'][Random.secure().nextInt(2)] ),
                      decoration: BoxDecoration(
                        color: whiteColor
                      ),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                    ),
                    SizedBox(width: 11),
                    [Widgets.statusPending(),
                      Widgets.statusCompleted(),
                      Widgets.statusApproved(),
                    ][Random.secure().nextInt(3)]
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}