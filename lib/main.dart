import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'values.dart';

import 'pages/splashcreen.dart';
import 'providers/main.dart';
import 'providers/user.dart';

Future _showNotificationWithDefaultSound(String title, String message) async {
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
  _showNotificationWithDefaultSound(
      message['data']['title'], message['data']['body']);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //getConfig();
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  firebaseMessaging.requestNotificationPermissions();

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) {
      print('onMessage called: $message');
      _showNotificationWithDefaultSound(
          message['data']['title'], message['data']['body']);

      //toast();

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

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
        ChangeNotifierProvider<MainModel>(create: (context) => MainModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    //print("0xff${primaryColor.value.toRadixString(16)}");
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          //primarySwatch: primarySwatch,
          ),
      home: splashScreen(),
    );
  }
}
