import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savehouse/pages/land.dart';
import 'package:savehouse/widgets.dart';

import '../values.dart';
import 'auth/login.dart';

Widget splashScreen() {
  return MaterialApp(
    //title: 'D',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Splash(),
  );
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();

    loading();
  }

  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
  }

  Future<Timer> loading() async {
    return Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    Get.off(Land());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          body: Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/splashscreen.jpg",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
              /* Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 250,
                child: Widgets.button('LOGIN', () => Get.off(Login())),
              ),
            ),
          ) */
            ],
          ),
          /* Image.asset(
        "assets/images/splash.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ), */ /* ScaleTransition(
          scale: animation,
          child: Center(
            child: Image.asset("assets/images/splash.png"),
          ),
        ), */
        ));
  }
}
