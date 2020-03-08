import 'package:flutter/material.dart';
import 'package:savehouse/widgets.dart';

import '../../values.dart';

class Earnings extends StatefulWidget {
  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {

  var earnings = [{
    'ref': '1091',
    'percentage': -10,
    'amount': -55200,
    'date': '09:30, 20 Mar, 2020',
  },{
    'ref': '1056',
    'percentage': 16,
    'amount': 89900,
    'date': '2020-03-09 23:59:59',
  },{
    'ref': '1033',
    'percentage': 0.5,
    'amount': 2450,
    'date': '2020-03-09 23:59:59',
  },{
    'ref': '1030',
    'percentage': -0.1,
    'amount': -100,
    'date': '2020-03-09 23:59:59',
  },{
    'ref': '1029',
    'percentage': 5.3,
    'amount': 22700,
    'date': '2020-03-09 23:59:59',
  },];

  var tempHolder = [];
  final tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Scope to create a Grid

    return Column(
      children: List.generate(earnings.length, (index){
        var _return = Container(height: 0,);
        var amt = double.tryParse( earnings[index]['amount'].toString() );

        tempHolder.add(Container(
          margin: index%2==0 ? EdgeInsets.only(right: 3) : EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all( color: shyColor )
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text( '${earnings[index]['ref']}', style: TextStyle( fontSize: 16 ), ),
                  Expanded(child: Container()),
                  Text( '${earnings[index]['percentage']}%', style: TextStyle( fontSize: 20, fontWeight: FontWeight.w400 ), ),
                  amt <= 0 ? Widgets.lossIcon() : Widgets.profitIcon(),
                ],
              ),
              SizedBox(height: 12,),
              Text( Widgets.currency( amt ), style: TextStyle( fontSize: 23, fontWeight: FontWeight.bold ), ),
              SizedBox(height: 12,),
              Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                child: Text(
                  earnings[index]['date'],
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ]
          ),
        ));

        if( index % 2 == 1 || earnings.length==index+1 ){
          _return = Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: List.generate(tempHolder.length, (ind) => Expanded(
                child: tempHolder[ind],
              )),
            ),
          );
          setState((){
            tempHolder = [];
          });
        }
        
        return _return;
      }),
    );
  }
}