import 'package:savehouse/models/investment.dart';

class Earning {
  final int id;
  final double percentage;
  final int investmentId;
  final DateTime addedAt;
  final String createdAt;
  final double amount;
  final bool isProfit;
  Investment investment;

  Earning({
    this.addedAt,
    this.createdAt,
    this.id,
    this.investmentId,
    this.percentage,
    this.amount,
    this.isProfit,
    this.investment,
  });

  factory Earning.fromMap(Map data) => Earning(
        id: data['id'],
        percentage: double.parse(data['percentage']),
        investmentId: int.parse(data['investment_id']),
        addedAt: DateTime.parse(data['added_at']),
        createdAt: data['created_at'],
        amount: data['amount'].toDouble(),
        isProfit: data['is_profit'],
      );
}
