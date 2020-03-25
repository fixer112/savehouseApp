import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/globals.dart';

import '../../providers/user.dart';
import '../../values.dart';
import '../../widgets.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  var username = TextEditingController();
  var password = TextEditingController();

  //var loading = false;
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserModel>(context, listen: false);
    getConfig(context);
    if (user.user != null) {
      FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
      firebaseMessaging.getToken().then((token) async {
        print('FCM Token: $token');
        var response = await http.post(
            '${user.hostUrl}/api/user/${user.user.id}/remove_token?api_token=${user.user.apiToken}',
            body: {
              'app_token': token,
            },
            headers: {
              'Accept': 'application/json',
            });
        print(json.decode(response.body));
      });
    }
  }

  @override
  Widget build(context) {
    //var main = Provider.of<MainModel>(context, listen: false);
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Consumer<UserModel>(builder: (context, user, child) {
            return Stack(children: [
              listLogin(user),
              Widgets.loader(user),
            ]);
          }),
        ),
      ),
    );
  }

  listLogin(UserModel user) {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        SizedBox(height: 100.0),
        Text(
          'Login',
          style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          'securely login to your safehouse account',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Text(
          'Username',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 40.0,
          margin: EdgeInsets.only(top: 10.0),
          child: Widgets.textField(username, 'username', TextInputType.text),
        ),
        SizedBox(height: 25),
        Text(
          'Password',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 40.0,
          margin: EdgeInsets.only(top: 10.0),
          child: Widgets.textField(
              password, '*******', TextInputType.visiblePassword),
        ),
        SizedBox(height: 25),
        FlatButton(
          color: primaryColor,
          child:
              /* user.isloading
                   // ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ))
                    : */
              Text(
            'LOGIN',
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            getConfig(context);
            if (!user.isloading) {
              if ([username.text, password.text].contains('')) {
                return getSnack('Error', 'All inputs required');
              }
              user.login(username.text, password.text, context, _scaffoldKey);
            }
            closeKeybord(context);
          },
        ),
        /* InkWell(
          child: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Text(
              'Don\'t have an account? Register',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () {
            
          },
        ), */
      ],
    );
  }
}
