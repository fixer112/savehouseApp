import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/pages/auth/login.dart';
import 'package:savehouse/pages/widgets/editprofile.dart';
import 'package:savehouse/providers/user.dart';
import 'package:savehouse/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../values.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Consumer<UserModel>(builder: (context, user, child) {
            return Widgets.pageTitle(
              'My Account',
              user.user.fullname,
              icon: 1,
              context: context,
              image: CircleAvatar(
                  backgroundImage: NetworkImage(url + user.user.profilePic)),
            );
          }),
          SizedBox(height: 40),
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                margin: EdgeInsets.only(bottom: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: shyColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Icon(
                    FontAwesomeIcons.userEdit,
                    size: 25,
                  ),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    showEditProfile(context);
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                margin: EdgeInsets.only(bottom: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: shyColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 25,
                    color: Colors.red,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 22,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Login())),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Widgets.bottomNav(3, context),
    );
  }
}
