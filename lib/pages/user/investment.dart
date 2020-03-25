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
        title: Text(
          widget.investment.ref,
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.replay),
        onPressed: () {
          //print('yes');
          getEarnings(reload: true);
        },
        //mini: ,
      ),
    );
  }

  body(user) {
    return ListView(
      padding: EdgeInsets.all(20.0),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        /*InkWell(
            onTap: () {
              showImagePreview(
                  context,
                  FlutterLogo(
                    colors: Colors.green,
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                  //border: Border( bottom: BorderSide( color: whiteColor ) )
                  ),
              height: 130,
              child: Stack(children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: FittedBox(
                    child: FlutterLogo(
                      colors: Colors.green,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(color: Colors.black.withOpacity(.5)),
              ]),
            ),
          ),*/
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
                  Text(
                    '${Widgets.ucfirst(widget.investment.type)} Investment',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
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
                      Text('${widget.investment.duration} Months',
                          style: TextStyle(fontSize: 15)),
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
                  Text(Widgets.currency(widget.investment.amount),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
                ],
              ),
              /* Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    widget.investment.parentRoll == null
                        ? Container()
                        : RichText(
                            text: TextSpan(
                                text: '${widget.investment.ref} is rolled from',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '${widget.investment.parentRoll.ref}',
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 18),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      InvestmentWidget(widget
                                                          .investment
                                                          .parentRoll)));
                                        })
                                ]),
                          ),
                  ]), */
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
