import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/models/investment.dart';
import 'package:http/http.dart' as http;
import 'package:savehouse/pages/widgets/investments.dart';
import 'package:savehouse/providers/user.dart';
import 'package:savehouse/providers/user.dart';

import '../globals.dart';

class User {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String fullname;
  final String email;
  final String apiToken;
  //final List<String> appToken;
  final String type;
  final String profilePic;
  final DateTime createdAt;
  List<Investment> investments;
  Map<String, dynamic> dynamicInvestments;
  var settings;

  User({
    this.id,
    this.username,
    this.firstname,
    this.fullname,
    this.lastname,
    this.email,
    this.apiToken,
    //this.appToken,
    this.type,
    this.profilePic,
    this.createdAt,
    this.investments,
    this.dynamicInvestments,
    this.settings,
  });

  factory User.fromMap(Map data) {
    /* var d = data['investments'].map((i) {
      return Investment.fromMap(i);
    }).toList();
    print(List<Investment>.from(d).runtimeType); */
    return User(
      id: data['id'],
      username: data['username'],
      firstname: data['fname'],
      lastname: data['lname'],
      fullname: data['full_name'],
      email: data['email'],
      apiToken: data['api_token'],
      type: data['type'],
      profilePic: data['profile_pic'],
      createdAt: DateTime.parse(data['created_at']) ?? null,
      /* investments: List<Investment>.from(
          data['investments'].map((i) => Investment.fromMap(i)).toList()),
       */ //appToken: data['app_token'],
    );
  }

  Future updateUser(BuildContext context, GlobalKey _scaffoldKey) async {
    //var user = Provider.of<userModel>(context, listen: false);
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      user.setLoading(true);
      final response = await http
          .get('${user.hostUrl}/api/user?api_token=${this.apiToken}', headers: {
        'Accept': 'application/json',
      });
      user.setLoading(false);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);
      request(response, () => user.setUser(User.fromMap(body)), context,
          _scaffoldKey);
    } catch (e) {
      user.setLoading(false);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  Future getAllInvestments(BuildContext context, GlobalKey _scaffoldKey) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      //var user = Provider.of<UserModel>(context);
      user.setLoading(true);
      final response = await http.get(
          '${user.hostUrl}/api/user/${this.id}?api_token=${this.apiToken}',
          headers: {
            'Accept': 'application/json',
          });
      user.setLoading(false);
      var body = json.decode(response.body);
      //print(body);
      request(response, () {
        this.investments = List<Investment>.from(
            body['investments'].map((i) => Investment.fromMap(i)).toList());
        body.removeWhere((String key, dynamic value) => key == 'investments');
        this.dynamicInvestments = Map();
        this.dynamicInvestments.addAll({'all': body});
      }, context, _scaffoldKey);
    } catch (e) {
      user.setLoading(false);
      print(e);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  Future getTypeInvestments(
      BuildContext context, GlobalKey _scaffoldKey, String type,
      {showLoad = true}) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      //var user = Provider.of<UserModel>(context);
      if (showLoad) {
        user.setLoading(true);
      }
      final response = await http.get(
          '${user.hostUrl}/api/user/${user.user.id}/investments/$type?api_token=${this.apiToken}',
          headers: {
            'Accept': 'application/json',
          });

      if (showLoad) {
        user.setLoading(false);
      }

      var body = json.decode(response.body);
      //print(body);
      request(response, () {
        body.removeWhere((String key, dynamic value) => key == 'investments');
        //this.dynamicInvestments = Map();
        this.dynamicInvestments.addAll({'$type': body});
      }, context, _scaffoldKey);
      return this.dynamicInvestments;
    } catch (e) {
      if (showLoad) {
        user.setLoading(false);
      }
      print(e);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  Map<String, Investments> investmentToggle() {
    Map<String, Investments> investments = {};
    investments.addAll({'all': Investments(this.investments)});
    this
        .settings['investments']
        .forEach((i) => investments.addAll({i: Investments(searchType(i))}));
    return investments;
  }

  List<Investment> searchType(String type) {
    return this
        .investments
        .where((investment) => investment.type == type)
        .toList();
  }
}
