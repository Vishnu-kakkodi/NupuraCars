// class Transaction {
//   final String id;
//   final double amount;
//   final String type;
//   final String message;
//   final DateTime date;

//   Transaction({
//     required this.id,
//     required this.amount,
//     required this.type,
//     required this.message,
//     required this.date,
//   });

//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     return Transaction(
//       id: json['_id'] ?? '',
//       amount: double.parse(json['amount'].toString()),
//       type: json['type'] ?? '',
//       message: json['message'] ?? '',
//       date: json['date'] != null 
//           ? DateTime.parse(json['date']) 
//           : DateTime.now(),
//     );
//   }
// }





class WalletResponse {
  final int totalWalletAmount;
  final List<Transaction> wallet;

  WalletResponse({
    required this.totalWalletAmount,
    required this.wallet,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      totalWalletAmount: json['totalWalletAmount'] ?? 0,
      wallet: (json['wallet'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e))
          .toList(),
    );
  }
}

class Transaction {
  final String id;
  final double amount;
  final String type;
  final String message;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.message,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }
}
