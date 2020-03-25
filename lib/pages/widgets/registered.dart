import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home.dart';

class Registered extends StatefulWidget {
  @override
  _RegisteredState createState() => _RegisteredState();
}

class _RegisteredState extends State<Registered> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            height: 410,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 30),
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: FlutterLogo(
                          colors: Colors.green,
                        )),
                    SizedBox(height: 70.0),
                    Text(
                      'Registeration\nSuccessful!',
                      style: TextStyle(
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'User Registered',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    FlatButton(
                      color: Colors.green,
                      child: Text(
                        'LET\'S GET STARTED',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Get.to(Home());
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void showRegisteredWidget(context) {
  showDialog(
    context: context,
    builder: (context) => Registered(),
  );
}
