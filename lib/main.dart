import 'package:flutter/material.dart';
import 'package:savehouse/pages/splashcreen.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/providers/main.dart';
import 'package:savehouse/providers/user.dart';
import 'package:savehouse/values.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
          ChangeNotifierProvider<MainModel>(create: (context) => MainModel()),
        ],
        child: MyApp(),
      ),
    );

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