import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';
import 'pages/user/account.dart';
import 'pages/user/activity.dart';
import 'pages/user/invest.dart';
import 'pages/widgets/editprofile.dart';
import 'providers/user.dart';
import 'values.dart';

class Widgets {
  static dropItem(String text, String value) {
    return DropdownMenuItem<String>(
      child: Row(
        children: <Widget>[
          //Icon(Icons.filter_1),
          Text(text),
        ],
      ),
      value: value,
    );
  }

  static text(String text,
      {double fontSize = 13,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black,
      TextAlign textAlign = TextAlign.start}) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: "MavinPro",
      ),
    );
  }

  static textField(TextEditingController controller, TextInputType type,
      {bool enabled = true, String hintText = "", Widget prefix}) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(top: 5.0),
      child: TextField(
          enabled: enabled,
          controller: controller,
          decoration: InputDecoration(
              prefix: prefix != null ? prefix : Text(""),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              fillColor: enabled ? Colors.white : shyColor,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: shyColor),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(32.0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: shyColor),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(32.0),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: shyColor),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(32.0),
                  )),
              //disabledBorder: ,
              /* border:
                  OutlineInputBorder(borderSide: BorderSide(color: shyColor)),
              enabled: enabled, */
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "MavinPro")),
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
                      fontFamily: 'MavinPro'),
                ),
                SizedBox(height: 4),
                Text(
                  supportText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: "MavinPro",
                  ),
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
                        Get.to(Account());
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
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              fontFamily: "MavinPro",
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.satellite,
            color: (index == 1 ? primaryColor : Colors.grey),
          ),
          title: Text(
            'Invest',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              fontFamily: "MavinPro",
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.note,
            color: (index == 2 ? primaryColor : Colors.grey),
          ),
          title: Text(
            'Activity',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              fontFamily: "MavinPro",
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
            color: (index == 3 ? primaryColor : Colors.grey),
          ),
          title: Text(
            'Account',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              fontFamily: "MavinPro",
            ),
          ),
        ),
      ],
      onTap: (ind) {
        if (ind == index) return;
        Get.off([
          Home(),
          Invest(),
          Consumer<UserModel>(builder: (context, user, child) {
            return Activity(user.user);
          }),
          Account(),
        ][ind]);
        /* Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => <Widget>[
                      Home(),
                      Invest(),
                      Consumer<UserModel>(builder: (context, user, child) {
                        return Activity(user.user);
                      }),
                      Account(),
                    ][ind])); */
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

  static toggleTabs(Map<String, Widget> widgets, context, cls) {
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
                            fontFamily: "MavinPro",
                          ),
                        ),
                        onTap: () {
                          // var user =
                          //     Provider.of<UserModel>(context, listen: false);
                          //print(user.user.dynamicInvestments['all']);
                          cls.setState(() {
                            cls.current = index;
                            //if (cls.) {
                            cls.type = key;
                            //}
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
          widgets.length < 1
              ? Text(
                  'No Investment Available',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "MavinPro",
                    /* shadows: Widgets.textShadows(color: shyColor) */
                  ),
                  textAlign: TextAlign.center,
                )
              : Row(
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
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontFamily: "MavinPro",
        ),
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
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontFamily: "MavinPro",
        ),
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
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontFamily: "MavinPro",
        ),
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
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontFamily: "MavinPro",
        ),
      ),
    );
  }

  static currency(number) {
    var f = NumberFormat("#,###");
    return '₦' + f.format(number); //globals.formatCurrency.format(number);
  }

  static loader(UserModel user) {
    return user.isloading
        ? Center(
            child:
                Logo() /* CircularProgressIndicator(
            strokeWidth: 3,
          ) */
            )
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

  static ucfirst(String string) {
    return string.replaceRange(0, 1, string.substring(0, 1).toUpperCase());
  }

  static floatReloadButton(action) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      child: Icon(Icons.replay),
      onPressed: () {
        //print(action().runtimeType);
        action();
      },
      //mini: ,
    );
  }

  static button(text, Function action, {Color color}) {
    return RaisedButton(
      padding: EdgeInsets.all(15),
      textColor: Colors.white,
      color: color == null ? primaryColor : color,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "MavinPro",
        ),
      ),
      onPressed: () => action(),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }
}

class Logo extends StatefulWidget {
  Logo({Key key}) : super(key: key);

  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));

    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        /* decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(100))), */
        ////color: primaryColor,
        //height: 100,
        //width: 100,
        child: Container(
          color: primaryColor,
          child: Image.asset(
            "assets/images/logo.png",
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
