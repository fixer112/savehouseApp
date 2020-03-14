import 'package:savehouse/models/investment.dart';

class Payment {
  final int id;
  final int investmentId;
  final String paidAt;
  //final String createdAt;
  final String amount;
  //final bool status;

  Payment({
    this.paidAt,
    //this.createdAt,
    this.id,
    this.investmentId,
    this.amount,
    //this.status,
  });

  factory Payment.fromMap(Map data) => Payment(
        id: data['id'],
        investmentId: int.parse(data['investment_id']),
        paidAt: data['paid_at'],
        //createdAt: data['created_at'],
        amount: data['amount'],
        // status: data['status'],
      );
}
