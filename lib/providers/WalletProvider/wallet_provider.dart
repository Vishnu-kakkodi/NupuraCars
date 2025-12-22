
import 'package:nupura_cars/models/BookingModel/transation_model.dart';
import 'package:nupura_cars/services/WalletService/wallet_service.dart';
import 'package:flutter/material.dart';


class WalletProvider extends ChangeNotifier {
  final WalletService _walletService = WalletService();

  double _balance = 0.0;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  double get balance => _balance;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Initialize wallet data
  Future<void> fetchWalletDetails(String userId) async {
    try {
            print("ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");

      _isLoading = true;
      _error = '';
      notifyListeners();

      final walletResponse = await _walletService.getWalletDetails(userId);

      _balance = walletResponse.totalWalletAmount.toDouble();
      print("ooooooooooooooooooooooooooooooooooooooooooooo$_balance");
      _transactions = walletResponse.wallet;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add amount to wallet
Future<void> addAmount(String userId, double amount, String transactionId) async {
  try {
    _isLoading = true;
    notifyListeners();

    // Call API to add amount
await _walletService.addAmount(userId, amount, transactionId);

    // Refresh wallet data
    await fetchWalletDetails(userId);

    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
  }
}


  // Format transaction date
  String formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
