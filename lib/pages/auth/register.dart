import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/pages/auth/login.dart';
import 'package:savehouse/pages/widgets/registered.dart';
import 'package:savehouse/providers/user.dart';
import 'package:savehouse/widgets.dart';

import '../../values.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {
  var username = TextEditingController();
  var password = TextEditingController();
  var fName = TextEditingController();
  var email = TextEditingController();
  var lName = TextEditingController();
  var confirmPassword = TextEditingController();
  var bankName = TextEditingController();
  var accountName = TextEditingController();
  var accountNumber = TextEditingController();

  //var loading = false;

  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [secondaryColor, primaryColor],
              begin: Alignment.topCenter, // FractionalOffset(0.5, 0.0),
              end: Alignment.bottomCenter, //FractionalOffset(0.0, 0.5),
              stops: [0.0, 1.0], tileMode: TileMode.clamp,
            ),
          ),
          child: Consumer<UserModel>(builder: (context, user, child) {
            return Stack(children: [
              listRegister(user),
              Widgets.loader(user),
            ]);
          }),
        ),
      ),
    );
  }

  listRegister(UserModel user) {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        SizedBox(height: 50.0),
        /* 
        Widgets.text('Register', fontSize: 27.0, fontWeight: FontWeight.bold),
        SizedBox(height: 4), */
        Center(
            child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          child: Container(
            color: primaryColor,
            child: Image.asset(
              "assets/images/deal.png",
              height: 50.0,
            ),
          ),
        )),
        SizedBox(height: 10.0),
        Center(
          child: Widgets.text("Sign UP",
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        /* Widgets.text(
            'create a free account and start a proper financial journey with saveHouse capital',
            fontSize: 13,
            fontWeight: FontWeight.bold), */
        SizedBox(height: 30),
        Center(
          child: Widgets.text('First Name',
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(fName, TextInputType.text),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Last Name',
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(lName, TextInputType.text),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Username',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(username, TextInputType.text),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Email Address',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(email, TextInputType.emailAddress),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Bank Name',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(bankName, TextInputType.text),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Account Name',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(accountName, TextInputType.text),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Account Number',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(accountNumber, TextInputType.text),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Password',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(password, TextInputType.visiblePassword),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Confirm Password',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(confirmPassword, TextInputType.phone),
        SizedBox(height: 25),
        Widgets.button("Register", () {
          var data = {
            'username': username.text,
            'fname': fName.text,
            'lname': lName.text,
            'email': email.text,
            'bank_name': bankName.text,
            'account_name': accountName.text,
            'account_number': accountNumber.text,
          };
          user.register(data, context, _scaffoldKey);

          /* Timer.periodic(Duration(seconds: 2), (t) {
            setState(() {
              loading = false;
            });
            showRegisteredWidget(context);
            t.cancel();
          }); */
        }),
        InkWell(
          child: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Widgets.text('Already have an account? Login',
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onTap: () {
            Get.to(Login());
          },
        ),
      ],
    );
  }
}
