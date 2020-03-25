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
            Text(
              'Register',
              style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'create a free account and start a proper financial journey with saveHouse capital',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Full Name',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Widgets.textField(fullName, 'Full Name', TextInputType.text),
            SizedBox(height: 25),
            Text(
              'Username',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Widgets.textField(username, '@johndoe', TextInputType.text),
            SizedBox(height: 25),
            Text(
              'Email Address',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Widgets.textField(
                email, 'Email Address', TextInputType.emailAddress),
            SizedBox(height: 25),
            Text(
              'Phone Number',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Widgets.textField(phone, 'Phone Number', TextInputType.phone),
            SizedBox(height: 25),
            Text(
              'Password',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Widgets.textField(
                password, '******', TextInputType.visiblePassword),
            SizedBox(height: 25),
            Text(
              'Referrer Phone',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Widgets.textField(
                ref, 'Referrer Phone or Promo Code', TextInputType.phone),
            SizedBox(height: 25),
            FlatButton(
              color: primaryColor,
              child: loading == true
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'REGISTER',
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
              onPressed: () {
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
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
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
