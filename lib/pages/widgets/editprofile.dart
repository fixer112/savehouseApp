import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
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

class _EditProfileState extends State<EditProfile> {
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
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
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
            height: 410,
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
                      Text(
                        'Edit Account',
                        style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () => getImage(),
                            child: Container(
                              //width: 100,
                              child:
                                  /* _image == null
                                  ? Text('No image selected.')
                                  : */ /* Image.file(
                                        _image)  */
                                  CircleAvatar(
                                      backgroundImage: _image == null
                                          ? NetworkImage(user.hostUrl +
                                              user.user.profilePic)
                                          : FileImage(_image)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Username',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Widgets.textField(
                          username, user.user.username, TextInputType.text,
                          enabled: false),
                      SizedBox(height: 25),
                      Text(
                        'First Name',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Widgets.textField(
                          firstName, user.user.firstname, TextInputType.text),
                      SizedBox(height: 25),
                      Text(
                        'Last Name',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Widgets.textField(
                          lastName, user.user.lastname, TextInputType.text),
                      SizedBox(height: 25),
                      Text(
                        'Email Address',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Widgets.textField(
                          email, user.user.email, TextInputType.emailAddress),
                      SizedBox(height: 25),
                      Text(
                        'Old Password (optional)',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Widgets.textField(
                          oldPass, '', TextInputType.visiblePassword),
                      SizedBox(height: 25),
                      Text(
                        'New Password (optional)',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Widgets.textField(
                          newPass, '', TextInputType.visiblePassword),
                      SizedBox(height: 25),
                      Text(
                        'Confirm Password (optional)',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Widgets.textField(
                          confirmPass, '', TextInputType.visiblePassword),
                      SizedBox(height: 25),
                      /* Text(
                        'Phone Number',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Widgets.textField(
                          phone, 'Phone Number', TextInputType.phone),
                      SizedBox(height: 25), */
                      FlatButton(
                        color: primaryColor,
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (!user.isloading) {
                            //user.user.updateUser(context, _scaffoldKey);
                            getData(user.user);
                          }
                          /*SnackBar(
                            content: Text( 'Successful!' ),
                            duration: Duration(seconds: 5),
                          );*/
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
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
