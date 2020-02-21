import 'dart:math';

import 'package:flutter/material.dart';
import 'package:savehouse/values.dart';
import 'package:savehouse/widgets.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Widgets.pageTitle(
            'My Activity',
            'monitor your account from here',
            context: context,
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 1,
                    color: primaryColor,
                  ),
                ),
                SizedBox(width: 15),
                Text('28 March, 2018'),
                SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 1,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(5, (index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Card(
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: shyColor),
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          [
                            'You logged in',
                            'You created an investment',
                            'You requested withdrawal',
                            'You canceled an investment plan'
                          ][Random.secure().nextInt(4)],
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            color: shyColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            child: Text('self'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Widgets.bottomNav(2, context),
    );
  }
}
