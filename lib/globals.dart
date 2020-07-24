import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/pages/auth/login.dart';
import 'package:savehouse/providers/user.dart';

import 'values.dart';
import 'widgets.dart';
import 'package:path_provider/path_provider.dart';

final String connErrorMsg = 'Connection Failed';

dialog(BuildContext context, String title, String body) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Widgets.text("Alert Dialog title"),
        content: Widgets.text("Alert Dialog body"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: Widgets.text("Close"),
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

  final snack = SnackBar(
      content: Widgets.text(text), duration: Duration(seconds: seconds));
  _scaffoldKey.currentState.removeCurrentSnackBar();
  _scaffoldKey.currentState.showSnackBar(snack);
}

alert(context, {title = '', content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Widgets.text(title),
        content: Widgets.text(content),
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
  if (statusCode == 401) {
    getSnack('Error', 'Please re login');
    return Get.off(Login());
  }
  if (statusCode == 422) {
    var errors = '';
    body['errors'].forEach((error, data) => errors += '${data[0]}\n');
    //return snackbar(errors, context, _scaffoldKey);
    return getSnack('Error', errors);
  }

  if (statusCode >= 200 && statusCode < 300) {
    if (body.containsKey('error')) {
      getSnack('Error', body['error']);
      //snackbar(body['error'], context, _scaffoldKey);
    }
    if (body.containsKey('success')) {
      getSnack('Alert', body['success']);
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

Future showNotificationWithDefaultSound(String title, String message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS =
      IOSInitializationSettings(onDidReceiveLocalNotification: null);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: null);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1', 'Notification', '',
      importance: Importance.Max, priority: Priority.Max, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    '$title',
    '$message',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

/* Future<dynamic> onSelectNotification(String n) {
  print(n);
} */

Future bgMsgHdl(Map<String, dynamic> message) async {
  print("onbgMessage: $message");
  showNotificationWithDefaultSound(
      message['data']['title'], message['data']['body']);
}

Future<Null> saveJson(String content, {String fileName = 'user.json'}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;
  File file = new File(path + "/" + fileName);
  file.createSync();
  file.writeAsStringSync((content));
}

Future getJson({String fileName = 'user.json'}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;
  var jsonFile = new File(path + "/" + fileName);
  bool fileExists = jsonFile.existsSync();
  return fileExists ? (jsonFile.readAsStringSync()) : null;
}

Future<Null> removeJson({String fileName = 'user.json'}) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String path = appDocDir.path;
  var jsonFile = new File(path + "/" + fileName);
  bool fileExists = jsonFile.existsSync();
  if (fileExists) jsonFile.delete();
}
