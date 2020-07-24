import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../globals.dart';
import '../pages/widgets/investments.dart';
import '../providers/user.dart';
import 'activity.dart';
import 'investment.dart';

class User {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String fullname;
  final String email;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String apiToken;
  //final List<String> appToken;
  final String type;
  final String profilePic;
  final String identityPic;
  final DateTime createdAt;
  List<Investment> investments;
  List<Activity> activities;
  Map<String, dynamic> dynamicInvestments;
  var settings;
  final String state;
  final String occupation;
  final String address;
  final String number;
  final DateTime dob;

  User({
    this.state,
    this.occupation,
    this.address,
    this.number,
    this.dob,
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
    this.activities,
    this.dynamicInvestments,
    this.settings,
    this.identityPic,
    this.accountName,
    this.accountNumber,
    this.bankName,
  });

  factory User.fromMap(Map data) {
    return User(
      id: data['id'],
      username: data['username'],
      firstname: data['fname'],
      lastname: data['lname'],
      fullname: data['full_name'],
      email: data['email'],
      bankName: data['bank_name'] ?? '',
      accountName: data['account_name'] ?? '',
      accountNumber: data['account_number'] ?? '',
      apiToken: data['api_token'],
      type: data['type'],
      profilePic: data['profile_pic'],
      identityPic: data['identity_pic'],
      createdAt: DateTime.parse(data['created_at']) ?? null,
      activities: [],
      state: data['state'] ?? '',
      occupation: data['occupation'] ?? '',
      address: data['address'] ?? '',
      number: data['number'] ?? '',
      dob: DateTime.parse(data['created_at']) ?? null,
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
      print(body);
      request(response, () async {
        user.setUser(User.fromMap(body));
        user.user.settings = body['settings'];
        await user.user.getAllInvestments(context, _scaffoldKey);
        // this.getAllInvestments(context, _scaffoldKey);
      }, context, _scaffoldKey);
    } catch (e) {
      user.setLoading(false);
      getSnack('Error', connErrorMsg);
      //snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  Future getAllInvestments(BuildContext context, GlobalKey _scaffoldKey) async {
    var user = Provider.of<UserModel>(context, listen: false);
    //print(user.hostUrl);
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
      print(body);
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
      //snackbar(connErrorMsg, context, _scaffoldKey);
      getSnack('Error', connErrorMsg);
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
      //snackbar(connErrorMsg, context, _scaffoldKey);
      getSnack('Error', connErrorMsg);
    }
  }

  Future getActivities(BuildContext context, GlobalKey _scaffoldKey,
      {showLoad = true, @required String from, @required String to}) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      //var user = Provider.of<UserModel>(context);
      if (showLoad) {
        user.setLoading(true);
      }
      final response = await http.get(
          '${user.hostUrl}/api/user/${user.user.id}/activity?api_token=${this.apiToken}&from=$from&to=$to',
          headers: {
            'Accept': 'application/json',
          });

      if (showLoad) {
        user.setLoading(false);
      }

      var body = json.decode(response.body);
      //print(body);
      request(response, () {
        this.activities = List<Activity>.from(
            body['activities'].map((i) => Activity.fromMap(i)).toList());
      }, context, _scaffoldKey);
      return this.activities;
    } catch (e) {
      if (showLoad) {
        user.setLoading(false);
      }
      print(e);
      //snackbar(connErrorMsg, context, _scaffoldKey);
      getSnack('Error', connErrorMsg);
    }
  }

  Map<String, Investments> investmentToggle() {
    Map<String, Investments> investments = {};
    investments.addAll({'all': Investments(this.investments)});
    this.settings['investments'].forEach(
        (type, i) => investments.addAll({type: Investments(searchType(type))}));
    return investments;
  }

  List<Investment> searchType(String type) {
    return this
        .investments
        .where((investment) => investment.type == type)
        .toList();
  }
}
