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
  var bankName = TextEditingController();
  var accountName = TextEditingController();
  var accountNumber = TextEditingController();
  var occupation = TextEditingController();
  var address = TextEditingController();
  var number = TextEditingController();
  var dob = TextEditingController();
  String state;
  //var phone = TextEditingController();

  var loading = false;
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;

  Animation<double> animation;
  AnimationController controller;

  Future getImage() async {
    final picker = ImagePicker();
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    //print(image.path);
    setState(() {
      _image = File(image.path);
    });
    //print(_image.path);
  }

  getData(User user) async {
    //print(oldPass.text);
    Map<String, dynamic> data = {
      'fname': firstName.text == '' ? user.firstname : firstName.text,
      'lname': lastName.text == '' ? user.lastname : lastName.text,
      'email': email.text == '' ? user.email : email.text,
      'occupation': occupation.text == '' ? user.occupation : occupation.text,
      'address': address.text == '' ? user.address : address.text,
      'number': number.text == '' ? user.number : number.text,
      'dob': dob.text == ''
          ? "${user.dob.month}/${user.dob.day}/${user.dob.year}"
          : dob.text,
      'state': state == null ? user.state : state,
      'bank_name': bankName.text == '' ? user.bankName : bankName.text,
      'account_name':
          accountName.text == '' ? user.accountName : accountName.text,
      'account_number':
          accountName.text == '' ? user.accountNumber : accountNumber.text,
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
      data.forEach((index, info) {
        request.fields[index] = info;
        print("$index:$info ");
      });
      /*  //var d = Map<String, dynamic>.from(data);
      request.fields['fname'] = data['fname'];
      request.fields['lname'] = data['lname'];
      request.fields['email'] = data['email'];
      request.fields['old_password'] = data['old_password'];
      request.fields['password'] = data['password'];
      request.fields['password_confirmation'] = data['password_confirmation']; */

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
              var states = user.user.settings['states'];
              var d = user.user.dob;
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
                      Widgets.text('State', fontWeight: FontWeight.bold),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: DropdownButton(
                          items: List.generate(states.length, (index) {
                            //var key = investments.keys.toList()[index];
                            var string = states[index].toString();
                            return Widgets.dropItem(
                                string.toUpperCase(), string);
                          }),
                          hint: Widgets.text(user.user.state ?? 'Choose State'),
                          value: state,
                          onChanged: (value) {
                            setState(() {
                              state = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      Widgets.text('Occupation', fontWeight: FontWeight.bold),
                      Widgets.textField(occupation, TextInputType.text,
                          hintText: user.user.occupation),
                      SizedBox(height: 25),
                      Widgets.text('Address', fontWeight: FontWeight.bold),
                      Widgets.textField(address, TextInputType.text,
                          hintText: user.user.address),
                      SizedBox(height: 25),
                      Widgets.text('Phone Number', fontWeight: FontWeight.bold),
                      Widgets.textField(number, TextInputType.text,
                          hintText: user.user.number),
                      SizedBox(height: 25),
                      Widgets.text('Date of Birth',
                          fontWeight: FontWeight.bold),
                      Widgets.textField(dob, TextInputType.text,
                          hintText: user.user.dob != null
                              ? "${d.month}/${d.day}/${d.year}"
                              : 'mm/dd/yyyy'),
                      SizedBox(height: 25),
                      Widgets.text('Bank Name', fontWeight: FontWeight.bold),
                      Widgets.textField(bankName, TextInputType.text,
                          hintText: user.user.bankName),
                      SizedBox(height: 25),
                      Widgets.text('Account Name', fontWeight: FontWeight.bold),
                      Widgets.textField(accountName, TextInputType.text,
                          hintText: user.user.accountNumber),
                      SizedBox(height: 25),
                      Widgets.text('Accouunt Number',
                          fontWeight: FontWeight.bold),
                      Widgets.textField(accountNumber, TextInputType.text,
                          hintText: user.user.accountNumber),
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
