import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savehouse/pages/auth/register.dart';
import 'package:savehouse/widgets.dart';

import '../values.dart';
import 'auth/login.dart';

class Land extends StatefulWidget {
  @override
  _LandState createState() => new _LandState();
}

class _LandState extends State<Land> with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    // var t= Timer(Duration(seconds: 10), Get.to(Land()));
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
    //loading();
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
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          body: Stack(
            children: <Widget>[
              PageView(children: [
                Image.asset(
                  "assets/images/artboard_1.jpg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/mining.jpg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/agric.jpg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/estate.jpg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    //width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                            width: 250,
                            child: Widgets.button(
                                'LOGIN', () => Get.off(Login()))),
                        SizedBox(height: 10),
                        SizedBox(
                            width: 250,
                            child: Widgets.button(
                                'REGISTER', () => Get.off(Register()))),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          /* Image.asset(
        "assets/images/Land.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ), */ /* ScaleTransition(
          scale: animation,
          child: Center(
            child: Image.asset("assets/images/Land.png"),
          ),
        ), */
        ));
  }
}
