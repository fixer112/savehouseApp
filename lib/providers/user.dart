import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/models/user.dart';
import 'dart:convert';
import 'package:savehouse/globals.dart';
import 'package:savehouse/pages/home.dart';
import 'package:savehouse/providers/user.dart';
import 'package:http/http.dart' as http;
import 'package:savehouse/values.dart';

class UserModel extends ChangeNotifier {
  User user;
  bool _loggedIn = false;
  bool _isLoading = false;
  final String hostUrl = url;

  setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  User get getUser => user;

  setLoggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isloading => _isLoading;
  bool get loggedIn => _loggedIn;
  /* getUser()async{
    
  } */

  Future login(
      String username, String password, context, GlobalKey _scaffoldKey) async {
    var user = Provider.of<UserModel>(context, listen: false);
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
        setUser(User.fromMap(body));
        user.user.settings = body['settings'];
        await user.user.getAllInvestments(context, _scaffoldKey);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      }, context, _scaffoldKey);
    } catch (e) {
      user.setLoading(false);
      print(e.message);
      //snackbar(e.message(), context, _scaffoldKey);
      return snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }
}
