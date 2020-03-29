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
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called: $message');
        showNotificationWithDefaultSound(
            message['data']['title'], message['data']['body']);
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called: $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
        return;
      },
      onBackgroundMessage: bgMsgHdl,
    );
    firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    firebaseMessaging.subscribeToTopic('global');

    var user = Provider.of<UserModel>(context, listen: false);

    getConfig(context);

    if (user.user != null) {
      //FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
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
    print(Theme.of(context).textTheme);
    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Colors.white,

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
            listLogin(user),
            Widgets.loader(user),
          ]);
        }),
      ),
    );
  }

  listLogin(UserModel user) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      children: <Widget>[
        SizedBox(height: 150.0),
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
          child: Widgets.text("Welcome",
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        /* Text(
          'Login',
          style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          'securely login to your safehouse account',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ), */
        SizedBox(height: 30),
        Center(
          child: Widgets.text('Username',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(username, TextInputType.text),
        SizedBox(height: 25),
        Center(
          child: Widgets.text('Password',
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Widgets.textField(password, TextInputType.visiblePassword),
        SizedBox(height: 25),
        Container(
          child: Widgets.button(
            "Login",
            () async {
              getConfig(context);
              if (!user.isloading) {
                if ([username.text, password.text].contains('')) {
                  return getSnack('Error', 'All inputs required');
                }
                user.login(username.text, password.text, context, _scaffoldKey);
              }
              closeKeybord(context);
            }, /* color: Colors.transparent */
          ),
        )
      ],
    );
  }
}
