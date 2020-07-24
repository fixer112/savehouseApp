import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:savehouse/pages/widgets/registered.dart';

import '../globals.dart';
import '../models/user.dart';
import '../pages/home.dart';

class UserModel extends ChangeNotifier {
  User user;
  RemoteConfig _config;
  bool _loggedIn = false;
  bool _isLoading = false;
  String hostUrl;

  setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  setConfig(RemoteConfig config) {
    _config = config;
    setUrl();
    notifyListeners();
  }

  RemoteConfig get getConfig => _config;

  setUrl() {
    hostUrl = kDebugMode
        ? 'https://savehouse.altechtic.com'
        : _config.getString('url');
    print(hostUrl);
  }

  User get getUser => user;

  setLoggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    Future.delayed(Duration(seconds: 1), () => notifyListeners());
  }

  bool get isloading => _isLoading;
  bool get loggedIn => _loggedIn;
  /* getUser()async{
    
  } */

  Future login(
      String username, String password, context, GlobalKey _scaffoldKey) async {
    var user = Provider.of<UserModel>(context, listen: false);
    //print(user);
    //var user = Provider.of<UserModel>(context);
    try {
      user.setLoading(true);
      //print('loading');
      final response = await http.post('${user.hostUrl}/api/login', body: {
        'username': username,
        'password': password,
      }, headers: {
        'Accept': 'application/json',
      });
      user.setLoading(false);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);

      request(response, () async {
        if (body != null) setUser(User.fromMap(body));
        user.user.settings = body['settings'];
        await user.user.getAllInvestments(context, _scaffoldKey);
        await removeJson(fileName: 'credentials.json');
        await saveJson(jsonEncode({'username': username}),
            fileName: 'credentials.json');
        Get.off(Home());
      }, context, _scaffoldKey);
    } catch (e) {
      user.setLoading(false);
      print(e);
      //snackbar(e.message(), context, _scaffoldKey);
      return getSnack('Error', connErrorMsg);
      //return snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  Future register(Map data, context, GlobalKey _scaffoldKey) async {
    var user = Provider.of<UserModel>(context, listen: false);
    //print(user);
    //var user = Provider.of<UserModel>(context);
    try {
      user.setLoading(true);
      //print('loading');
      final response =
          await http.post('${user.hostUrl}/api/register', body: data, headers: {
        'Accept': 'application/json',
      });
      user.setLoading(false);
      print(response.statusCode);
      print(response.body);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);
      request(response, () async {
        await removeJson(fileName: 'credentials.json');
        await saveJson(jsonEncode({'username': data['username']}),
            fileName: 'credentials.json');
        showRegisteredWidget(context);
      }, context, _scaffoldKey);
    } catch (e) {
      user.setLoading(false);
      print(e);
      //snackbar(e.message(), context, _scaffoldKey);
      return getSnack('Error', connErrorMsg);
      //return snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }
}
