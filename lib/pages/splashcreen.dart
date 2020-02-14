import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savehouse/pages/auth/login.dart';

import '../values.dart';

Widget splashScreen(){
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

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    Loading();
  }

  Future<Timer> Loading() async {
    return Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (BuildContext context) => Login()
    ));
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: secondaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Image.asset('assets/images/panic_alert.png', height: 100.0,),
              //SizedBox(height: 30.0,),
              Text(
                'SaveHouse Capital',
                style: TextStyle(fontSize: 30.0, color: primaryColor),
              ),
            ],
          ),
        )
      ),
    );
  }
}