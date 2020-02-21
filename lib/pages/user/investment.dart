import 'package:flutter/material.dart';
import 'package:savehouse/pages/widgets/imagepreview.dart';
import 'package:savehouse/widgets.dart';

import '../../values.dart';

class Investment extends StatefulWidget {
  @override
  _InvestmentState createState() => _InvestmentState();
}

class _InvestmentState extends State<Investment> {
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
        /* leading: IconButton(
          icon: Icon( Icons.keyboard_arrow_left, color: secondaryColor, ),
          onPressed: (){

          },
        ), */
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
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
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Widgets.statusCompleted(),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Real Estate Investment',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Text('N6,000,000',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: FlatButton(
              color: secondaryColor,
              child: Text(
                'CANCEL',
                style: TextStyle(color: primaryColor),
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
