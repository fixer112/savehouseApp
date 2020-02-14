import 'package:flutter/material.dart';
import 'package:savehouse/values.dart';
import 'package:savehouse/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Widgets.pageTitle( 'Matnex', 'Good Morning' ),
            SizedBox(height: 20),
            Container(
              height: 90,
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index){
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    margin: EdgeInsets.symmetric( horizontal: 3.0 ),
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon( Icons.multiline_chart, color: whiteColor, size: 37, ),
                        SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text( 'Monthly Earnings', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold ), ),
                            SizedBox(height: 4),
                            Text( 'N200,000,000.00', style: TextStyle( color: whiteColor, fontSize: 19.0, fontWeight: FontWeight.w900, shadows: Widgets.textShadows() ),),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Widgets.bottomNav(1),
      ),
    );
  }
}