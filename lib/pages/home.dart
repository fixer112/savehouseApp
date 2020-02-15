import 'package:flutter/material.dart';
import 'package:savehouse/pages/widgets/investments.dart';
import 'package:savehouse/values.dart';
import 'package:savehouse/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Widgets.pageTitle(
              'Matnex,',
              'Good Morning',
              context: context,
            ),
            SizedBox(height: 20),
            Container(
              height: 90,
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 3.0),
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.multiline_chart,
                          color: Colors.white,
                          size: 37,
                        ),
                        SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Monthly Earnings',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'N200,000,000.00',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w900,
                                  shadows: Widgets.textShadows()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Investments',
              style: TextStyle(
                  fontSize: 20,
                  shadows: Widgets.textShadows(color: whiteColor)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Widgets.toggleTabs({
              'All': Investments(),
              'Real Estate': Investments(),
              'Forex': Investments(),
            }, this),
          ],
        ),
        bottomNavigationBar: Widgets.bottomNav(0, context),
      ),
    );
  }
}
