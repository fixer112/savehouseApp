import 'package:flutter/material.dart';
import 'package:savehouse/pages/widgets/imagepreview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savehouse/widgets.dart';
import 'package:savehouse/pages/widgets/earnings.dart';

import '../../values.dart';

class InvestmentWidget extends StatefulWidget {
  @override
  _InvestmentState createState() => _InvestmentState();
}

class _InvestmentState extends State<InvestmentWidget> {

  var balances = [{
    'title': 'Total Earnings (Monthly)',
    'value': 200000,
  }];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          '8omFfXp3AGG1pO1',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon( Icons.keyboard_arrow_left, color: secondaryColor, ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          /*InkWell(
            onTap: () {
              showImagePreview(
                  context,
                  FlutterLogo(
                    colors: Colors.green,
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                  //border: Border( bottom: BorderSide( color: whiteColor ) )
                  ),
              height: 130,
              child: Stack(children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: FittedBox(
                    child: FlutterLogo(
                      colors: Colors.green,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(color: Colors.black.withOpacity(.5)),
              ]),
            ),
          ),*/
          Container(
            height: 90,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: balances.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: index % 2 != 0 ? primaryColor : secondaryColor,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.chartBar,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(width: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            balances[index]['title'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            Widgets.currency(balances[index]['value']),
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w900,
                              //shadows: Widgets.textShadows(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Widgets.statusCompleted(),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Estate Investment',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('3 Months',
                            style:
                                TextStyle(fontSize: 15)),
                        IconButton(
                          icon: Icon( FontAwesomeIcons.externalLinkSquareAlt, size: 18, color: secondaryColor, ),
                          onPressed: (){
                            showImagePreview(
                              context,
                              FlutterLogo(
                                colors: Colors.green,
                              ));
                          },
                        ),
                      ],
                    ),
                    Text( Widgets.currency(600000),
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox( height: 5,),
          Text(
            'Earnings',
            style: TextStyle(
                fontSize: 20, shadows: Widgets.textShadows(color: shyColor)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30,),
          Earnings(),
        ],
      ),
    );
  }
}
