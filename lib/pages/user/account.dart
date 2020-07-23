import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/pages/auth/login.dart';
import 'package:savehouse/pages/widgets/editprofile.dart';
import 'package:savehouse/pages/widgets/imagepreview.dart';
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
      body: Consumer<UserModel>(builder: (context, user, child) {
        var image = Image.network(
          user.hostUrl + user.user.identityPic,
          fit: BoxFit.fill,
        );
        return ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Widgets.pageTitle(
              'My Account',
              user.user.fullname,
              icon: 1,
              context: context,
              image: CircleAvatar(
                  backgroundImage:
                      NetworkImage(user.hostUrl + user.user.profilePic)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.withOpacity(.4),
              ),
              height: 150,
              child: InkWell(
                onTap: () => showImagePreview(context, image),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: image,
                ),
              ),
            ),
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
                    title: Widgets.text(
                      'Edit Profile',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
                    title: Widgets.text(
                      'Logout',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.red,
                    ),
                    onTap: () {
                      user.user = null;
                      Get.to(Login());
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      }),
      bottomNavigationBar: Widgets.bottomNav(3, context),
    );
  }
}
