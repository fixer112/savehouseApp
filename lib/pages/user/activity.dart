import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user.dart';
import '../../values.dart';
import '../../widgets.dart';

class Activity extends StatefulWidget {
  User user;
  Activity(this.user);
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getActivitys();
  }

  getActivitys({reload = false}) async {
    //print(widget.user.activities);
    if (widget.user.activities.isEmpty || reload) {
      await widget.user.getActivities(context, _scaffoldKey);
      /* .then((e) {
        var user = Provider.of<UserModel>(context, listen: false);
        Investment invest = user.user.investments
            .where((i) => i.id == widget.investment.id)
            .first;
        //print(invest);
        widget.investment.earnings = invest.earnings;
        setState(() {});
      }); */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  body(user) {
    var now = DateTime.now();
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
              SizedBox(width: 15),
              Text(DateFormat("dd-MM-yyyy").format(now)),
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
                      Text(
                        widget.user.activities[index].summary,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 6.0),
                            child: Text(
                              widget.user.activities[index].createdAt,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                          //Text(widget.user.activities[index].createdAt),
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
                              child: Text(widget.user.activities[index].by),
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
