import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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

getSnack(title, message, {int duration = 5}) {
  Get.snackbar(title, message,
      duration: Duration(seconds: duration),
      //snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(15),
      //backgroundColor: secondaryColor,
      backgroundGradient:
          LinearGradient(colors: [secondaryColor, primaryColor]));
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
                
              },
            ),
          ], */
      );
    },
  );
}

processResponse(statusCode, body, Function action, context, _scaffoldKey) {
  if (statusCode == 422) {
    var errors = '';
    body['errors'].forEach((error, data) => errors += '${data[0]}\n');
    //return snackbar(errors, context, _scaffoldKey);
    return getSnack('Error', errors);
  }

  if (statusCode == 200) {
    if (body.containsKey('error')) {
      getSnack('Error', body['error']);
      //snackbar(body['error'], context, _scaffoldKey);
    }
    if (body.containsKey('success')) {
      getSnack('Error', body['success']);
      //snackbar(body['success'], context, _scaffoldKey);
    }
    action();
  } else {
    //print(body);
    return getSnack('Error', 'An error occured, Please try later.');
    /*  return snackbar(
        'An error occured, Please try later.', context, _scaffoldKey); */
  }
}

request(Response response, Function action, context, GlobalKey _scaffoldKey) {
  print(response.statusCode);
  var body = json.decode(response.body);
  //print(body);
  return processResponse(
      response.statusCode, body, action, context, _scaffoldKey);
}

request2(String string, int statusCode, Function action, context,
    GlobalKey _scaffoldKey) {
  print(statusCode);
  var body = json.decode(string);
  //print(body);

  return processResponse(statusCode, body, action, context, _scaffoldKey);
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
    'url': 'http://client.safehousecapital.ng',
    'timeout': 20,
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
