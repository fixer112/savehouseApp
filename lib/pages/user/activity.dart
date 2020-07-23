import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user.dart';
import '../../values.dart';
import '../../widgets.dart';
import 'dart:async';

class Activity extends StatefulWidget {
  User user;
  Activity(this.user);
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  @override
  void initState() {
    super.initState();
    getActivitys();
  }

  getActivitys({reload = false}) async {
    //print(widget.user.activities);
    if (widget.user.activities.isEmpty || reload) {
      String _from = from != null
          ? DateFormat("dd-MM-yyyy").format(from)
          : DateFormat("dd-MM-yyyy").format(now);
      String _to = from != null
          ? DateFormat("dd-MM-yyyy").format(to)
          : DateFormat("dd-MM-yyyy").format(now);
      await widget.user
          .getActivities(context, _scaffoldKey, from: _from, to: _to);
    }
  }

  Future<DateTime> _selectDate(BuildContext context, DateTime initial) async {
    initial = initial != null ? initial : now;
    initial = initial.isBefore(now) ? now : now.subtract(Duration(days: 1));
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2020),
        lastDate: now);
    return picked;
  }

  Future getTo(BuildContext context) async {
    var date = await _selectDate(context, to);
    print(date);
    if (date != null) {
      setState(() {
        to = date;
      });

      if (from != null && from.isBefore(to)) return getActivitys(reload: true);
    }
  }

  Future getFrom(BuildContext context) async {
    var date = await _selectDate(context, from);
    print(date);
    if (date != null) {
      setState(() {
        from = date;
      });

      if (to != null && to.isAfter(from)) return getActivitys(reload: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
          body: Consumer<UserModel>(builder: (context, user, child) {
            return Stack(children: [
              body(user),
              Widgets.loader(user),
            ]);
          }),
          floatingActionButton: //Container(),
              Widgets.floatReloadButton(() {
            getActivitys(reload: true);
          }),
          bottomNavigationBar: Widgets.bottomNav(2, context),
        ));
  }

  body(user) {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        Widgets.pageTitle(
          'My Activity',
          'monitor your account from here',
          context: context,
          image: CircleAvatar(
              backgroundImage:
                  NetworkImage(user.hostUrl + user.user.profilePic)),
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
              SizedBox(width: 10),
              InkWell(
                  onTap: () => getFrom(context),
                  child: Widgets.text(DateFormat("dd-MM-yyyy").format(from))),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                  onTap: () => getTo(context),
                  child: Widgets.text(DateFormat("dd-MM-yyyy").format(to))),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
        /*  widget.user.activities.length < 1
            ? Container()
            : */
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(widget.user.activities.length, (index) {
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
                      Widgets.text(widget.user.activities[index].summary,
                          fontSize: 15),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 6.0),
                            child: Widgets.text(
                              widget.user.activities[index].createdAt,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: shyColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              //color: shyColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              child: Widgets.text(
                                  widget.user.activities[index].by),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
