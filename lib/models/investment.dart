import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savehouse/globals.dart';
import 'package:savehouse/models/earning.dart';
import 'package:savehouse/models/payment.dart';
import 'package:savehouse/models/user.dart';
import 'package:savehouse/providers/user.dart';
import 'package:http/http.dart' as http;

class Investment {
  final int id;
  final String currency;
  final int userId;
  final double amount;
  final int duration;
  final String type;
  final String proofPic;
  final DateTime approvedAt;
  final String status;
  final String method;
  final String activeStatus;
  final String ref;
  final bool isActive;
  final bool isComplete;
  final DateTime createdAt;
  final String startDate;
  final String endDate;
  User user;
  List<Earning> earnings;
  List<Payment> payments;
  Investment parentRoll;
  Investment childRoll;
  Map<String, dynamic> dynamicData;

  Investment({
    this.currency,
    this.id,
    this.activeStatus,
    this.amount,
    this.approvedAt,
    this.createdAt,
    this.duration,
    this.endDate,
    this.isActive,
    this.isComplete,
    this.method,
    this.proofPic,
    this.ref,
    this.startDate,
    this.status,
    this.type,
    this.userId,
    this.user,
    this.earnings,
    this.payments,
    this.childRoll,
    this.parentRoll,
    this.dynamicData,
  });
  factory Investment.fromMap(Map data) => Investment(
        id: data['id'],
        currency: data['currency'],
        activeStatus: data['active_status'],
        amount: double.parse(data['amount']),
        approvedAt: data['approved_at'] != null
            ? DateTime.parse(data['approved_at'])
            : null,
        createdAt: DateTime.parse(data['created_at']),
        duration: int.parse(data['duration']),
        endDate: data['end_date'],
        isActive: data['is_active'],
        isComplete: data['is_complete'],
        method: data['method'],
        proofPic: data['proof_pic'],
        ref: data['ref'],
        startDate: data['start_date'],
        status: data['status'],
        type: data['type'],
        userId: int.parse(data['user_id']),
        earnings: [],
        payments: [],
        dynamicData: {},
        parentRoll: data['parent_roll'] != null
            ? Investment.fromMap(data['parent_roll'])
            : null,
        childRoll: data['child_roll'] != null
            ? Investment.fromMap(data['child_roll'])
            : null,
        /* earnings: List<Earning>.from(data['earnings']
            .map((earning) => Earning.fromMap(earning))
            .toList()), */
      );

  Future getAllEarnings(BuildContext context, GlobalKey _scaffoldKey,
      {showLoad = true}) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      //var user = Provider.of<UserModel>(context);
      if (showLoad) {
        user.setLoading(true);
      }
      final response = await http.get(
          '${user.hostUrl}/api/user/${user.user.id}/investment/${this.ref}?api_token=${user.user.apiToken}',
          headers: {
            'Accept': 'application/json',
          });
      if (showLoad) {
        user.setLoading(false);
      }
      var body = json.decode(response.body);
      //print(body);
      request(response, () {
        this.earnings = List<Earning>.from(
            body['earnings'].map((e) => Earning.fromMap(e)).toList());
        // print(this.earnings);
        this.payments = List<Payment>.from(
            body['payments'].map((e) => Payment.fromMap(e)).toList());
        body.removeWhere((String key, dynamic value) =>
            key == 'earnings' && key == 'payments');
        this.dynamicData = Map();
        this.dynamicData.addAll(body);
      }, context, _scaffoldKey);
      return this.earnings;
      //print(this.earnings);
    } catch (e) {
      if (showLoad) {
        user.setLoading(false);
      }
      print(e);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }
}
