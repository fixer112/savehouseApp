import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savehouse/pages/auth/login.dart';
import 'package:savehouse/pages/widgets/registered.dart';
import 'package:savehouse/widgets.dart';

import '../../values.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {
  var username = TextEditingController();
  var password = TextEditingController();
  var fullName = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var ref = TextEditingController();

  var loading = false;

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            SizedBox(height: 100.0),
            Widgets.text('Register',
                fontSize: 27.0, fontWeight: FontWeight.bold),
            SizedBox(height: 4),
            Widgets.text(
                'create a free account and start a proper financial journey with saveHouse capital',
                fontSize: 13,
                fontWeight: FontWeight.bold),
            SizedBox(height: 30),
            Widgets.text('Full Name',
                fontSize: 13, fontWeight: FontWeight.bold),
            Widgets.textField(fullName, TextInputType.text),
            SizedBox(height: 25),
            Widgets.text('Username', fontWeight: FontWeight.bold),
            Widgets.textField(username, TextInputType.text),
            SizedBox(height: 25),
            Widgets.text('Email Address', fontWeight: FontWeight.bold),
            Widgets.textField(email, TextInputType.emailAddress),
            SizedBox(height: 25),
            Widgets.text('Phone Number', fontWeight: FontWeight.bold),
            Widgets.textField(phone, TextInputType.phone),
            SizedBox(height: 25),
            Widgets.text('Password', fontWeight: FontWeight.bold),
            Widgets.textField(password, TextInputType.visiblePassword),
            SizedBox(height: 25),
            Widgets.text('Referrer Phone', fontWeight: FontWeight.bold),
            Widgets.textField(ref, TextInputType.phone),
            SizedBox(height: 25),
            Widgets.button("Register", () {
              setState(() {
                loading = true;
              });
              Timer.periodic(Duration(seconds: 2), (t) {
                setState(() {
                  loading = false;
                });
                showRegisteredWidget(context);
                t.cancel();
              });
            }),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Widgets.text('Already have an account? Login',
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Get.to(Login());
              },
            ),
          ],
        ),
      ),
    );
  }
}
