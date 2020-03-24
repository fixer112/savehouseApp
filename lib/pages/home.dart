import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:savehouse/globals.dart';

import '../models/user.dart';
import '../providers/user.dart';
import '../values.dart';
import '../widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current = 0;
  List<Map> balances = [];
  String type = 'all';
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserModel>(context, listen: false);

    /* if (user.user != null) {
      final QuickActions quickActions = QuickActions();
      quickActions.initialize((shortcutType) {
        if (shortcutType == 'action_main') {
          print('The user tapped on the "Main view" action.');
        }
        // More handling code...
      });

      quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(
            type: 'action_main',
            localizedTitle: 'Main view',
            icon: 'icon_main'),
        const ShortcutItem(
            type: 'action_help', localizedTitle: 'Help', icon: 'icon_help')
      ]);
    }
 */
    firebaseMessaging.getToken().then((token) async {
      print('FCM Token: $token');
      var response = await http.post(
          '${user.hostUrl}/api/user/${user.user.id}/update_token?api_token=${user.user.apiToken}',
          body: {
            'app_token': token,
          },
          headers: {
            'Accept': 'application/json',
          });
      print(json.decode(response.body));
    });
  }

  addBalance(investment) {
    balances.add({
      'title': 'Total Investments (This Month)',
      'value': investment['monthInvestmentSum'],
    });
    balances.add({
      'title': 'Total Investments (This Year)',
      'value': investment['yearInvestmentSum'],
    });
    balances.add({
      'title': 'Total Investments (All Time)',
      'value': investment['allInvestmentSum'],
    });
    balances.add({
      'title': 'Total Earnings (This Month)',
      'value': investment['monthEarningSum'],
    });
    balances.add({
      'title': 'Total Earnings (This Year)',
      'value': investment['yearEarningSum'],
    });
    balances.add({
      'title': 'Total Earnings (All Time)',
      'value': investment['allEarningSum'],
    });
  }

  getSums(User user, {reload = false}) {
    balances = [];
    var investments = user.dynamicInvestments;
    //print(user.apiToken);

    if (type == 'all') {
      if (reload) {
        user.getAllInvestments(context, _scaffoldKey);
      }
      addBalance(investments[type]);
    } else {
      //var user = Provider.of<UserModel>(context, listen: false);
      if (investments.containsKey(type) && !reload) {
        addBalance(investments[type]);
        return;
      }
      user
          .getTypeInvestments(
        context,
        _scaffoldKey,
        type, /* showLoad: false */
      )
          .then((i) {
        setState(() {
          addBalance(i[type]);
        });
      });

      //print(investments[type]);

      /* balances.add({
        'title': 'Total Investments (This Month)',
        'value': investments[type]['monthInvestmentSum'],
      }); */
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          key: _scaffoldKey,
          body: Consumer<UserModel>(builder: (context, user, child) {
            return Stack(children: [
              body(user),
              Widgets.loader(user),
            ]);
          }),
          floatingActionButton:
              Consumer<UserModel>(builder: (context, user, child) {
            return Widgets.floatReloadButton(
                () => getSums(user.user, reload: true));
          }),
          bottomNavigationBar: Widgets.bottomNav(0, context),
        ),
      ),
    );
  }

  body(UserModel user) {
    getSums(user.user);
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        Widgets.pageTitle(
          '${user.user.firstname},',
          'Good ' + greeting(),
          context: context,
          image: CircleAvatar(
              backgroundImage:
                  NetworkImage(user.hostUrl + user.user.profilePic)),
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
        SizedBox(height: 40),
        Text(
          'Investments',
          style: TextStyle(
              fontSize: 20, shadows: Widgets.textShadows(color: shyColor)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Widgets.toggleTabs(user.user.investmentToggle(), context, this),
      ],
    );
  }
}
