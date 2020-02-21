import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savehouse/globals.dart';

import '../../values.dart';
import '../../widgets.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var username = TextEditingController();
  var fullName = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();

  var loading = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            height: 410,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Edit Account',
                      style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Full Name',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Widgets.textField(
                        fullName, 'Full Name', TextInputType.text),
                    SizedBox(height: 25),
                    Text(
                      'Username',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Widgets.textField(username, '@johndoe', TextInputType.text),
                    SizedBox(height: 25),
                    Text(
                      'Email Address',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Widgets.textField(
                        email, 'Email Address', TextInputType.emailAddress),
                    SizedBox(height: 25),
                    Text(
                      'Phone Number',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Widgets.textField(
                        phone, 'Phone Number', TextInputType.phone),
                    SizedBox(height: 25),
                    FlatButton(
                      color: primaryColor,
                      child: loading == true
                          ? SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'SAVE',
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        Timer.periodic(Duration(seconds: 2), (t) {
                          setState(() {
                            loading = false;
                          });
                          /*SnackBar(
                            content: Text( 'Successful!' ),
                            duration: Duration(seconds: 5),
                          );*/
                          t.cancel();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 417,
            height: 40,
            width: 40,
            right: 7,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                size: 23,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

void showEditProfile(context) {
  showDialog(
      context: context,
      builder: (context) {
        return EditProfile();
      });
}
