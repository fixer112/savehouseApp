import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savehouse/pages/auth/register.dart';
import 'package:savehouse/pages/home.dart';

import '../../values.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  var username = TextEditingController();
  var password = TextEditingController();
  var loading = false;

  @override
  Widget build( context ){
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            SizedBox(height: 100.0),
            Text( 'Login', style: TextStyle( fontSize: 27.0, fontWeight: FontWeight.bold ),),
            SizedBox(height: 4),
            Text( 'securely login to your safehouse account', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold ), ),
            SizedBox(height: 30),

            Text( 'Username', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold ), ),
            Container(
              height: 40.0,
              margin: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  fillColor: whiteColor,
                  filled: true,
                  border: OutlineInputBorder( borderSide: BorderSide.none ),
                  hintText: '@johndoe',
                  hintStyle: TextStyle( fontFamily: 'Agency FB', color: Colors.black, fontWeight: FontWeight.bold )
                ),
                keyboardType: TextInputType.text
              ),
            ),
            SizedBox(height: 25),

            Text( 'Password', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold ), ),
            Container(
              height: 40.0,
              margin: EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                  fillColor: whiteColor,
                  filled: true,
                  border: OutlineInputBorder( borderSide: BorderSide.none ),
                  hintText: '******',
                  hintStyle: TextStyle( fontFamily: 'Agency FB', color: Colors.black, fontWeight: FontWeight.bold )
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword
              ),
            ),
            SizedBox(height: 25),

            FlatButton(
              color: primaryColor,
              child: loading==true ?
                SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator( strokeWidth: 2, )
                )
              : Text( 'LOGIN', style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold ), ),
              onPressed: (){
                setState(() {
                  loading = true;
                });
                Timer.periodic(Duration(seconds: 2), (t){
                  setState(() {
                    loading = false;
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context) => Home()
                  ));
                  t.cancel();
                });
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text( 'Don\'t have an account? Register', style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold ), ),
              ),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (BuildContext context) => Register()
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}