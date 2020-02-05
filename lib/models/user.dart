import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/models/investment.dart';
import 'package:http/http.dart' as http;
import 'package:savehouse/providers/main.dart';
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
    var main = Provider.of<MainModel>(context);
    var user = Provider.of<UserModel>(context);
    try {
      main.setLoading(true);
      final response = await http
          .get('${main.hostUrl}/api/user?api_token=${this.apiToken}', headers: {
        'Accept': 'application/json',
      });
      main.setLoading(false);
      var body = json.decode(response.body).containsKey('data')
          ? json.decode(response.body)['data']
          : json.decode(response.body);
      request(response, () => user.setUser(User.fromMap(body)), context,
          _scaffoldKey);
    } catch (e) {
      main.setLoading(false);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  Future getAllInvestments(BuildContext context, GlobalKey _scaffoldKey) async {
    var main = Provider.of<MainModel>(context);
    try {
      //var user = Provider.of<UserModel>(context);
      main.setLoading(true);
      final response = await http.get(
          '${main.hostUrl}/api/user/${this.id}?api_token=${this.apiToken}',
          headers: {
            'Accept': 'application/json',
          });
      main.setLoading(false);
      var body = json.decode(response.body);
      request(
          response,
          () => this.investments = List<Investment>.from(
              body['investments'].map((i) => Investment.fromMap(i)).toList()),
          context,
          _scaffoldKey);
    } catch (e) {
      main.setLoading(false);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }
}
