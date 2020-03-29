import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/investment.dart';
import '../../providers/user.dart';
import '../../values.dart';
import '../../widgets.dart';
import '../widgets/earnings.dart';
import '../widgets/imagepreview.dart';
import '../widgets/payments.dart';

class InvestmentWidget extends StatefulWidget {
  Investment investment;

  InvestmentWidget(this.investment);

  @override
  _InvestmentState createState() => _InvestmentState();
}

class _InvestmentState extends State<InvestmentWidget> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  int current = 0;
  String type = 'earnings';
  List<Map> balances = [];

  getBalance() {
    balances = [];

    var data = widget.investment.dynamicData;
    //print(data);
    //return;

    if (data.length > 0) {
      balances.add({
        'title': 'Total Earnings (This Month)',
        'value': data['monthEarningSum'],
      });
      balances.add({
        'title': 'Total Earnings (This Year)',
        'value': data['yearEarningSum'],
      });
      balances.add({
        'title': 'Total Earnings (All Time)',
        'value': data['allEarningSum'],
      });

      balances.add({
        'title': 'Total Payments (This Month)',
        'value': data['monthPaymentSum'],
      });
      balances.add({
        'title': 'Total Payments (This Year)',
        'value': data['yearPaymentSum'],
      });
      balances.add({
        'title': 'Total Payments (All Time)',
        'value': data['allPaymentSum'],
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings({reload = false}) async {
    // print(widget.investment.earnings);
    if (widget.investment.earnings.isEmpty || reload) {
      await widget.investment.getAllEarnings(context, _scaffoldKey);
      print(widget.investment.payments);
      getBalance();
      /*  .then((e) {
        //var user = Provider.of<UserModel>(context, listen: false);
         Investment invest = user.user.investments
            .where((i) => i.id == widget.investment.id)
            .first;
        // print(e);
        //widget.investment.earnings = e.earnings;
        //setState(() {});
      }); 
      */
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.investment.earnings);
    getBalance();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Widgets.text(widget.investment.ref,
            color: secondaryColor, fontWeight: FontWeight.bold),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: secondaryColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Consumer<UserModel>(builder: (context, user, child) {
        return Stack(children: [
          body(user),
          Widgets.loader(user),
        ]);
      }),
      floatingActionButton:
          Widgets.floatReloadButton(() => getEarnings(reload: true)),
    );
  }

  body(user) {
    return ListView(
      padding: EdgeInsets.all(20.0),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          height: 90,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
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
                        Widgets.text(balances[index]['title'],
                            color: Colors.white),
                        SizedBox(height: 4),
                        Widgets.text(Widgets.currency(balances[index]['value']),
                            fontWeight: FontWeight.w900, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Widgets.status(widget.investment.activeStatus,
                      widget.investment.isActive),
                  SizedBox(
                    height: 12,
                  ),
                  Widgets.text(
                      '${Widgets.ucfirst(widget.investment.type)} Investment',
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Widgets.text('${widget.investment.duration} Months',
                          fontSize: 15),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.externalLinkSquareAlt,
                          size: 18,
                          color: secondaryColor,
                        ),
                        onPressed: () {
                          showImagePreview(
                            context,
                            Image.network(
                                user.hostUrl + widget.investment.proofPic),
                          );
                        },
                      ),
                    ],
                  ),
                  Widgets.text(Widgets.currency(widget.investment.amount),
                      fontSize: 25, fontWeight: FontWeight.w600)
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Widgets.toggleTabs({
          'Earnings': Earnings(widget.investment.earnings),
          'Payments': Payments(widget.investment.payments)
        }, context, this),
      ],
    );
  }
}
