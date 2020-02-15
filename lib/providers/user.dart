import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/models/user.dart';
import 'dart:convert';
import 'package:savehouse/globals.dart';
import 'package:savehouse/providers/main.dart';
import 'package:http/http.dart' as http;

class UserModel with ChangeNotifier {
  User user;

  setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
  /* getUser()async{
    
  } */

  Future login(
      String username, String password, context, GlobalKey _scaffoldKey) async {
    var main = Provider.of<MainModel>(context, listen: false);
    //var user = Provider.of<UserModel>(context);
    try {
      main.setLoading(true);
      //print('loading');
      final response = await http.post('${main.hostUrl}/api/login', body: {
        'username': username,
        'password': password,
      }, headers: {
        'Accept': 'application/json',
      });
      main.setLoading(false);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);

      request(
          response, () => setUser(User.fromMap(body)), context, _scaffoldKey);
    } catch (e) {
      main.setLoading(false);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }
}
