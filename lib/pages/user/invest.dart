import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savehouse/pages/home.dart';
import 'package:savehouse/pages/widgets/popup.dart';
import 'package:savehouse/widgets.dart';

import '../../values.dart';

class Invest extends StatefulWidget {
  @override
  _InvestState createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  var loading = false;
  
  var amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Widgets.pageTitle(
            'Invest',
            'start a new journey, savely',
            context: context,
            icon: false,
          ),

          SizedBox(height: 40,),

          Text( 'Amount to Invest', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold ), ),
          Widgets.textField(amount, 'Amount', TextInputType.numberWithOptions()),
          SizedBox(height: 25),

          FlatButton(
            color: primaryColor,
            child: loading==true ?
              SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator( strokeWidth: 2 ),
              )
            : Text( 'INVEST', style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold, ), ),
            onPressed: (){
              setState(() {
                loading = true;
              });
              Timer.periodic(Duration(seconds: 2), (t){
                setState(() {
                  loading = false;
                });
                
                showSuccessPopUp(context, 'Investment Added Successfully', (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Home()));
                });
                t.cancel();
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Widgets.bottomNav(1, context),
    );
  }
}