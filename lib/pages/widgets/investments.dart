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
                Widgets.text(investment.ref,
                    fontWeight: FontWeight.bold, fontSize: 16),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Widgets.text(Widgets.currency(investment.amount),
                          fontSize: 15),
                      SizedBox(width: 10),
                      Widgets.text('/', fontSize: 19),
                      SizedBox(width: 10),
                      Widgets.text('${investment.duration.toString()} months',
                          fontSize: 15),
                    ],
                  ),
                ),
                Widgets.text('${investment.roi?.toString()}% per month',
                    fontSize: 15),
                investment.startDate.contains('pending')
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Widgets.text(
                              investment.startDate,
                            ),
                            SizedBox(width: 10),
                            Widgets.text('-', fontSize: 19),
                            SizedBox(width: 10),
                            Widgets.text(
                              investment.endDate,
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
                      child: Widgets.text(
                          "${investment.type.toUpperCase()} (${investment.subType?.toLowerCase()})"),
                      decoration: BoxDecoration(color: shyColor),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                    ),
                    //SizedBox(width: 15),
                  ],
                ),
                SizedBox(height: 15),
                Widgets.status(investment.activeStatus, investment.isActive),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
