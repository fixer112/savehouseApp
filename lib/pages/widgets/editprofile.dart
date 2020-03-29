import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/models/user.dart';
import 'package:savehouse/providers/user.dart';

import '../../globals.dart';
import '../../values.dart';
import '../../widgets.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with SingleTickerProviderStateMixin {
  var username = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var oldPass = TextEditingController();
  var newPass = TextEditingController();
  var confirmPass = TextEditingController();
  var email = TextEditingController();
  //var phone = TextEditingController();

  var loading = false;
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;

  Animation<double> animation;
  AnimationController controller;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //print(image.path);
    setState(() {
      _image = image;
    });
    //print(_image.path);
  }

  getData(User user) async {
    //print(oldPass.text);
    Map<String, dynamic> data = {
      'fname': firstName.text == '' ? user.firstname : firstName.text,
      'lname': lastName.text == '' ? user.lastname : lastName.text,
      'email': email.text == '' ? user.email : email.text,
      'old_password': oldPass.text,
      'password': newPass.text,
      'password_confirmation': confirmPass.text,
    };
    /* if (_image != null) {
      data.addAll({'pic': base64Encode(_image.readAsBytesSync())});
    } */

    //return print(data);

    await editProfile(context, _scaffoldKey, data);
  }

  Future editProfile(BuildContext context, GlobalKey _scaffoldKey,
      Map<String, dynamic> data) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      user.setLoading(true);
      var url =
          '${user.hostUrl}/api/user/${user.user.id}/edit?api_token=${user.user.apiToken}';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      //var d = Map<String, dynamic>.from(data);
      request.fields['fname'] = data['fname'];
      request.fields['lname'] = data['lname'];
      request.fields['email'] = data['email'];
      request.fields['old_password'] = data['old_password'];
      request.fields['password'] = data['password'];
      request.fields['password_confirmation'] = data['password_confirmation'];

      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('pic', _image.path));
      }
      request.headers['Accept'] = 'application/json';
      var res = await request.send();
      var resStr = await res.stream.bytesToString();

      user.setLoading(false);
      //print(res.statusCode);
      print(resStr);
      request2(
          resStr,
          res.statusCode,
          () async => await user.user.updateUser(context, _scaffoldKey),
          context,
          _scaffoldKey);
      /*  if (res.statusCode == 200) {
        var body = json.decode(resStr);
        snackbar(body['success'], context, _scaffoldKey);
        await user.user.updateUser(context, _scaffoldKey);
      } */
      return;
    } catch (e) {
      user.setLoading(false);
      print(e);
      getSnack('Error', connErrorMsg);
      //snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animation = Tween<double>(begin: 0, end: 410).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        /*  if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        } */
      });

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            height: animation.value,
            left: 0,
            right: 0,
            child: Consumer<UserModel>(builder: (context, user, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Widgets.text(
                        'Edit Account',
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () => getImage(),
                            child: Container(
                              //width: 100,
                              child: CircleAvatar(
                                  backgroundImage: _image == null
                                      ? NetworkImage(
                                          user.hostUrl + user.user.profilePic)
                                      : FileImage(_image)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Widgets.text('Username', fontWeight: FontWeight.bold),
                      Widgets.textField(username, TextInputType.text,
                          enabled: false, hintText: user.user.username),
                      SizedBox(height: 25),
                      Widgets.text('First Name', fontWeight: FontWeight.bold),
                      Widgets.textField(firstName, TextInputType.text,
                          hintText: user.user.firstname),
                      SizedBox(height: 25),
                      Widgets.text('Last Name', fontWeight: FontWeight.bold),
                      Widgets.textField(lastName, TextInputType.text,
                          hintText: user.user.lastname),
                      SizedBox(height: 25),
                      Widgets.text('Email Address',
                          fontWeight: FontWeight.bold),
                      Widgets.textField(email, TextInputType.emailAddress,
                          hintText: user.user.email),
                      SizedBox(height: 25),
                      Widgets.text('Old Password (optional)',
                          fontWeight: FontWeight.bold),
                      Widgets.textField(oldPass, TextInputType.visiblePassword),
                      SizedBox(height: 25),
                      Widgets.text('New Password (optional)',
                          fontWeight: FontWeight.bold),
                      Widgets.textField(newPass, TextInputType.visiblePassword),
                      SizedBox(height: 25),
                      Widgets.text('Confirm Password (optional)',
                          fontWeight: FontWeight.bold),
                      Widgets.textField(
                          confirmPass, TextInputType.visiblePassword),
                      SizedBox(height: 25),
                      Widgets.button('Edit', () {
                        if (!user.isloading) {
                          getData(user.user);
                        }
                        closeKeybord(context);
                      })
                    ],
                  ),
                ),
              );
            }),
          ),
          Positioned(
            bottom: animation.value + 7,
            height: 40,
            width: 40,
            right: 7,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                size: 23,
                color: secondaryColor,
              ),
              onPressed: () {
                controller.reverse().then((d) {
                  Get.back();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 205),
            child: Align(
              //alignment: Alignment.bottomCenter,
              child: Consumer<UserModel>(builder: (context, user, child) {
                return Widgets.loader(user);
              }),
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
