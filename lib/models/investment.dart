import 'package:savehouse/models/earning.dart';
import 'package:savehouse/models/user.dart';

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
        /* earnings: List<Earning>.from(data['earnings']
            .map((earning) => Earning.fromMap(earning))
            .toList()), */
      );
}
