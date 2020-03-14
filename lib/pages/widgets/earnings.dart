import 'package:flutter/material.dart';
import 'package:savehouse/models/earning.dart';
import 'package:savehouse/widgets.dart';

import '../../values.dart';

class Earnings extends StatefulWidget {
  final List<Earning> earnings;

  Earnings(this.earnings);
  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  var tempHolder = [];
  final tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Scope to create a Grid
    // widget.earnings = [];
    return widget.earnings.length < 1
        ? Center(
            //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 55),
            child: Text(
              'No Earning Available',
              style: TextStyle(
                  fontSize: 20, shadows: Widgets.textShadows(color: shyColor)),
              textAlign: TextAlign.center,
            ),
          )
        : Column(
            children: List.generate(widget.earnings.length, (index) {
              var _return = Container(
                height: 0,
              );
              var amt =
                  double.tryParse(widget.earnings[index].amount.toString());

              tempHolder.add(Container(
                margin: index % 2 == 0
                    ? EdgeInsets.only(right: 3)
                    : EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: shyColor)),
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '${widget.earnings[index].id}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Expanded(child: Container()),
                          Text(
                            '${widget.earnings[index].percentage}%',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          amt <= 0 ? Widgets.lossIcon() : Widgets.profitIcon(),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        Widgets.currency(amt),
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 6.0),
                        child: Text(
                          widget.earnings[index].addedAt,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ]),
              ));

              if (index % 2 == 1 || widget.earnings.length == index + 1) {
                _return = Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: List.generate(
                        tempHolder.length,
                        (ind) => Expanded(
                              child: tempHolder[ind],
                            )),
                  ),
                );
                setState(() {
                  tempHolder = [];
                });
              }

              return _return;
            }),
          );
  }
}