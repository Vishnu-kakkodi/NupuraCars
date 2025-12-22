import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/models/BookingModel/transation_model.dart';


class WalletService {
  /// Get wallet balance and transaction history
  Future<WalletResponse> getWalletDetails(String userId) async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.getWallet}/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.jsonHeaders,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WalletResponse.fromJson(json);
      } else {
        throw Exception('Failed to load wallet: ${response.statusCode} | ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching wallet details: $e');
    }
  }

  /// Add amount to wallet with transactionId
  Future<WalletResponse> addAmount(String userId, double amount, String transactionId) async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.addAmount}/$userId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: ApiConstants.jsonHeaders,
        body: jsonEncode({
          'amount': amount,
          'transactionId': transactionId,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WalletResponse.fromJson(json);
      } else {
        throw Exception('Failed to add amount: ${response.statusCode} | ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding amount to wallet: $e');
    }
  }
}
