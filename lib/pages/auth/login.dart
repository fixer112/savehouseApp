import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/pages/auth/register.dart';
import 'package:savehouse/pages/home.dart';
import 'package:savehouse/providers/main.dart';
import 'package:savehouse/providers/user.dart';
import 'package:savehouse/widgets.dart';
import 'package:savehouse/widgets.dart';

import '../../values.dart';

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
  Widget build(context) {
    //var main = Provider.of<MainModel>(context, listen: false);
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Consumer<UserModel>(builder: (context, user, child) {
          return Stack(children: [
            listLogin(user),
            Widgets.loader(user),
          ]);
        }),
      ),
    );
  }

  listLogin(user) {
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
            /* user.setLoading(true);
                  Timer.periodic(Duration(seconds: 2), (t) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Home()));
                    user.setLoading(false);

                    t.cancel();
                  }); */
            user.login('user', 'abula112', context, _scaffoldKey);
          },
        ),
        InkWell(
          child: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Text(
              'Don\'t have an account? Register',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Register()));
          },
        ),
      ],
    );
  }
}
