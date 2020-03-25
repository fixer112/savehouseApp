import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/providers/user.dart';

import '../../models/investment.dart';
import '../../values.dart';
import '../../widgets.dart';
import '../user/investment.dart';
import 'imagepreview.dart';

class Investments extends StatefulWidget {
  final List<Investment> investments;
  Investments(this.investments);
  @override
  _InvestmentsState createState() => _InvestmentsState();
}

class _InvestmentsState extends State<Investments> {
  @override
  Widget build(BuildContext context) {
    //print(widget.investments[0]);
    List<Investment> investments = widget.investments;
    return Consumer<UserModel>(builder: (context, user, child) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(investments.length, (index) {
            //var key = investments.keys.toList()[index];
            return investmentEach(context, investments[index], user);
          }),
        ),
      );
    });
  }
}

Widget investmentEach(context, Investment investment, UserModel user) {
  //print(url + investment.proofPic);
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: shyColor),
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: EdgeInsets.only(top: 10, bottom: 15),
    child: Row(
      children: <Widget>[
        InkWell(
          child: Container(
            height: 90,
            width: 90,
            child: FittedBox(
              child: Image.network(user.hostUrl + investment.proofPic),
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            showImagePreview(
              context,
              Image.network(user.hostUrl + investment.proofPic),
            );
          },
        ),
        InkWell(
          onTap: () {
            Get.to(InvestmentWidget(investment));
          },
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  investment.ref,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Widgets.currency(investment.amount),
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '/',
                        style: TextStyle(fontSize: 19),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${investment.duration.toString()} months',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                investment.startDate.contains('pending')
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              investment.startDate,
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '-',
                              style: TextStyle(fontSize: 19),
                            ),
                            SizedBox(width: 10),
                            Text(
                              investment.endDate,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                Row(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Text(investment.type.toUpperCase()),
                      decoration: BoxDecoration(color: shyColor),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                    ),
                    SizedBox(width: 15),
                    Widgets.status(
                        investment.activeStatus, investment.isActive),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
