import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/pages/widgets/investments.dart';
import 'package:savehouse/providers/user.dart';
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
    /* balances.add({
      'title': 'Total Investments',
      'value': '525,000.00',
    });
    balances.add({
      'title': 'Total Investments (Annual)',
      'value': '525,000.00',
    });
    balances.add({
      'title': 'Total Earnings (Monthly)',
      'value': '181,500.00',
    });
    balances.add({
      'title': 'Total Earnings (Annual)',
      'value': '334,250.00',
    });
    balances.add({
      'title': 'Total Investments (All Time)',
      'value': '2,775,000.00',
    });
    balances.add({
      'title': 'Total Earnings (All Time)',
      'value': '1,013,500.00',
    }); */

    super.initState();
  }

  getSums(investments) {
    balances = [];

    balances.add({
      'title': 'Total Investments (This Month)',
      'value': investments['all']['monthInvestmentSum'],
    });
    balances.add({
      'title': 'Total Investments (This Year)',
      'value': investments['all']['yearInvestmentSum'],
    });
    balances.add({
      'title': 'Total Investments (All Time)',
      'value': investments['all']['allInvestmentSum'],
    });
    balances.add({
      'title': 'Total Earnings (This Month)',
      'value': investments['all']['monthEarningSum'],
    });
    balances.add({
      'title': 'Total Earnings (This Year)',
      'value': investments['all']['yearEarningSum'],
    });
    balances.add({
      'title': 'Total Earnings (All Time)',
      'value': investments['all']['allEarningSum'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Consumer<UserModel>(builder: (context, user, child) {
              return Widgets.pageTitle(
                '${user.user.firstname},',
                'Good Morning',
                context: context,
                image: CircleAvatar(
                    backgroundImage: NetworkImage(url + user.user.profilePic)),
              );
            }),
            SizedBox(height: 20),
            Consumer<UserModel>(builder: (context, user, child) {
              //print(user.user);
              getSums(user.user.dynamicInvestments);

              return Container(
                height: 90,
                child: PageView.builder(
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
              );
            }),
            SizedBox(height: 40),
            Text(
              'Investments',
              style: TextStyle(
                  fontSize: 20, shadows: Widgets.textShadows(color: shyColor)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Consumer<UserModel>(builder: (context, user, child) {
              return Widgets.toggleTabs(
                  user.user.investmentToggle(), context, this);
            }),
          ],
        ),
        bottomNavigationBar: Widgets.bottomNav(0, context),
      ),
    );
  }
}
