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
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: widget.earnings.length < 1
            ? Center(
                //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 55),
                child: Widgets.text(
                  'No Earning Available',
                  fontSize: 20,
                  /* shadows: Widgets.textShadows(color: shyColor) */

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
                              Widgets.text('${widget.earnings[index].id}',
                                  fontSize: 16),
                              Expanded(child: Container()),
                              Widgets.text(
                                  '${widget.earnings[index].percentage}%',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                              amt <= 0
                                  ? Widgets.lossIcon()
                                  : Widgets.profitIcon(),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Widgets.text(Widgets.currency(amt),
                              fontSize: 23, fontWeight: FontWeight.bold),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 6.0),
                            child: Widgets.text(widget.earnings[index].addedAt,
                                color: Colors.white),
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
              ));
  }
}
