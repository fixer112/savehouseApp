import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values.dart';
import 'auth/login.dart';

Widget splashScreen() {
  return MaterialApp(
    title: 'D',
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
    // var t= Timer(Duration(seconds: 10), Get.to(Splash()));
    /* Future.delayed(Duration(seconds: 20), () {
      getSnack('Timeout', 'You are forced to re-login after 20 minutes');
      Get.to(Login());
    }); */
    /* controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    

    animation = Tween(begin: 1.0, end: 1.5)
        .animate(CurvedAnimation(parent: controller, curve: Curves.bounceIn))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
            else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
    controller.forward(); */
    loading();
  }

  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
  }

  Future<Timer> loading() async {
    return Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Get.off(Login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Image.asset(
        "assets/images/splash.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ), /* ScaleTransition(
          scale: animation,
          child: Center(
            child: Image.asset("assets/images/splash.png"),
          ),
        ), */
    );
  }
}
