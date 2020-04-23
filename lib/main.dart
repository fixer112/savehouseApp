import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/pages/auth/login.dart';
import 'values.dart';

import 'pages/splashcreen.dart';
import 'providers/main.dart';
import 'providers/user.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //getConfig();

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Flutter Demo',
      navigatorKey: Get.key,
      theme: ThemeData(
          primaryColor: primaryColor,
          cursorColor: primaryColor,
          primarySwatch: primarySwatch,
          backgroundColor: shyColor,
          iconTheme: IconThemeData(color: whiteColor)
          /* textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ), */
          ),
      home: /*  Login(), */ splashScreen(),
    );
  }
}
