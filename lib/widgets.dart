import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/globals.dart';
import 'package:savehouse/models/user.dart';
import 'package:savehouse/pages/home.dart';
import 'package:savehouse/pages/user/account.dart';
import 'package:savehouse/pages/user/activity.dart';
import 'package:savehouse/pages/user/invest.dart';
import 'package:savehouse/pages/widgets/editprofile.dart';
import 'package:savehouse/pages/widgets/investments.dart';
import 'package:savehouse/providers/user.dart';

import 'values.dart';

class Widgets {
  static textField(
      TextEditingController controller, String hintText, TextInputType type) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(top: 10.0),
      child: TextField(
          controller: controller,
          decoration: InputDecoration(
              fillColor: shyColor,
              filled: true,
              border:
                  OutlineInputBorder(borderSide: BorderSide(color: shyColor)),
              hintText: hintText,
              contentPadding: EdgeInsets.all(10),
              hintStyle: TextStyle(
                  fontFamily: 'FB Agency',
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          obscureText: type == TextInputType.visiblePassword ? true : false,
          keyboardType: type),
    );
  }

  static pageTitle(mainText, supportText, {icon: true, Widget image, context}) {
    return Container(
        margin: EdgeInsets.only(top: 50),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  mainText,
                  style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Corbel'),
                ),
                SizedBox(height: 4),
                Text(
                  supportText,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            icon == false
                ? Container()
                : IconButton(
                    icon: image != null
                        ? image
                        : Icon(
                            Icons.account_circle,
                            color: primaryColor,
                            size: 37,
                          ),
                    onPressed: () {
                      if (icon == 1 && context != null) {
                        showEditProfile(context);
                      } else if (context != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Account(),
                            ));
                      }
                    },
                  ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ));
  }

  static bottomNav(index, context) {
    return BottomNavigationBar(
      currentIndex: index,
      fixedColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: (index == 0 ? primaryColor : Colors.grey),
          ),
          title: Text(
            'Home',
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.satellite,
            color: (index == 1 ? primaryColor : Colors.grey),
          ),
          title: Text(
            'Invest',
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.note,
            color: (index == 2 ? primaryColor : Colors.grey),
          ),
          title: Text(
            'Activity',
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
            color: (index == 3 ? primaryColor : Colors.grey),
          ),
          title: Text(
            'Account',
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      onTap: (ind) {
        if (ind == index) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => <Widget>[
                      Home(),
                      Invest(),
                      Activity(),
                      Account(),
                    ][ind]));
      },
    );
  }

  static textShadows({color = Colors.black}) {
    return <Shadow>[
      Shadow(color: color, offset: Offset(1, 1), blurRadius: .4),
      Shadow(color: color, offset: Offset(1, -1), blurRadius: .4),
      Shadow(color: color, offset: Offset(-1, 1), blurRadius: .4),
      Shadow(color: color, offset: Offset(-1, -1), blurRadius: .4),
    ];
  }

  static toggleTabs(Map<String, Investments> widgets, context, cls) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: shyColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: List.generate(widgets.length, (index) {
                  var key = widgets.keys.toList()[index];
                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: index == cls.current ? primaryColor : null,
                        border: (index == widgets.length - 1 ||
                                index == cls.current)
                            ? null
                            : Border(right: BorderSide(color: whiteColor)),
                      ),
                      child: InkWell(
                        child: Text(
                          '${key.toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: index == cls.current ? Colors.white : null,
                          ),
                        ),
                        onTap: () {
                          // var user =
                          //     Provider.of<UserModel>(context, listen: false);
                          //print(user.user.dynamicInvestments['all']);
                          cls.setState(() {
                            cls.current = index;
                            cls.type = key;
                          });
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: List.generate(widgets.length, (index) {
              var value = widgets.values.toList()[index];
              return index == cls.current
                  ? Expanded(
                      child: Container(child: value),
                    )
                  : Container();
            }),
          ),
        ],
      ),
    );
  }

  static status(String status, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? successColor : dangerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Text(
        status,
        style: TextStyle(fontSize: 13, color: Colors.white),
      ),
    );
  }

  static statusPending() {
    return Container(
      decoration: BoxDecoration(
        color: dangerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Text(
        'pending',
        style: TextStyle(fontSize: 13, color: Colors.white),
      ),
    );
  }

  static statusApproved() {
    return Container(
      decoration: BoxDecoration(
        color: successColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Text(
        'approved',
        style: TextStyle(fontSize: 13, color: Colors.white),
      ),
    );
  }

  static statusCompleted() {
    return Container(
      decoration: BoxDecoration(
        color: successColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Text(
        'completed',
        style: TextStyle(fontSize: 13, color: Colors.white),
      ),
    );
  }

  static currency(number) {
    var f = NumberFormat("#,###");
    return '₦' + f.format(number); //globals.formatCurrency.format(number);
  }

  static loader(user) {
    return user.isloading
        ? Center(
            child: CircularProgressIndicator(
            strokeWidth: 3,
          ))
        : Container();
  }

  static profitIcon() {
    return Icon(
      Icons.arrow_upward,
      size: 20,
      color: successColor,
    );
  }

  static lossIcon() {
    return Icon(
      Icons.arrow_downward,
      size: 20,
      color: dangerColor,
    );
  }
}
