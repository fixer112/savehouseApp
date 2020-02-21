import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savehouse/pages/widgets/investments.dart';
import 'package:savehouse/values.dart';
import 'package:savehouse/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current = 0;
  List<Map> balances = [];

  @override
  void initState() {
    
    balances.add({ 'title': 'Total Investments', 'value': '525,000.00', 'color': Colors.red });
    balances.add({ 'title': 'Total Investments (Annual)', 'value': '525,000.00', 'color': primaryColor });
    balances.add({ 'title': 'Total Earnings (Monthly)', 'value': '181,500.00', 'color': Colors.blueAccent });
    balances.add({ 'title': 'Total Earnings (Annual)', 'value': '334,250.00', 'color': Colors.lightGreen });
    balances.add({ 'title': 'Total Investments (All Time)', 'value': '2,775,000.00', 'color': Colors.teal });
    balances.add({ 'title': 'Total Earnings (All Time)', 'value': '1,013,500.00', 'color': Colors.deepOrange });
    
    super.initState();
  }

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
                itemCount: balances.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: balances[index]['color'],
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
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'N'+balances[index]['value'],
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
