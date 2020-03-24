import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/providers/user.dart';
import 'package:savehouse/values.dart';

final String connErrorMsg = 'Connection Failed';

dialog(BuildContext context, String title, String body) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Alert Dialog title"),
        content: new Text("Alert Dialog body"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

toast() {
  Fluttertoast.showToast(
      msg: 'test',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 5,
      backgroundColor: secondaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

snackbar(text, BuildContext context, _scaffoldKey, {seconds = 5}) {
  /*  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 5,
      backgroundColor: secondaryColor,
      textColor: Colors.white,
      fontSize: 16.0); */

  final snack =
      SnackBar(content: Text(text), duration: Duration(seconds: seconds));
  _scaffoldKey.currentState.removeCurrentSnackBar();
  _scaffoldKey.currentState.showSnackBar(snack);
}

alert(context, {title = '', content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        /* actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ], */
      );
    },
  );
}

request(Response response, Function action, context, GlobalKey _scaffoldKey) {
  print(response.statusCode);
  var body = json.decode(response.body);
  print(body);

  if (response.statusCode == 422) {
    var errors = '';
    body['errors'].forEach((error, data) => errors += '${data[0]}\n');
    return snackbar(errors, context, _scaffoldKey);
  }

  if (response.statusCode == 200) {
    if (body.containsKey('error')) {
      snackbar(body['error'], context, _scaffoldKey);
    }
    if (body.containsKey('success')) {
      snackbar(body['success'], context, _scaffoldKey);
    }
    action();
  } else {
    //print(body);
    return snackbar(
        'An error occured, Please try later.', context, _scaffoldKey);
  }
}

request2(String string, int statusCode, Function action, context,
    GlobalKey _scaffoldKey) {
  print(statusCode);
  var body = json.decode(string);
  //print(body);

  if (statusCode == 422) {
    var errors = '';
    body['errors'].forEach((error, data) => errors += '${data[0]}\n');
    return snackbar(errors, context, _scaffoldKey);
  }

  if (statusCode == 200) {
    if (body.containsKey('error')) {
      snackbar(body['error'], context, _scaffoldKey);
    }
    if (body.containsKey('success')) {
      snackbar(body['success'], context, _scaffoldKey);
    }
    action();
  } else {
    print(body);
    return snackbar(
        'An error occured, Please try later.', context, _scaffoldKey);
  }
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

closeKeybord(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

getConfig(BuildContext context) async {
  var user = Provider.of<UserModel>(context, listen: false);
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  final defaults = <String, dynamic>{
    'url': 'http://client.safehousecapital.ng'
  };
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  await remoteConfig.setDefaults(defaults);

  try {
    await remoteConfig.fetch(expiration: Duration(seconds: 0));
    await remoteConfig.activateFetched();
  } catch (e) {
    print(e);
  }
  user.setConfig(remoteConfig);
  print('welcome message: ' + user.hostUrl);

  // print(remoteConfig);
  //return remoteConfig;
}
