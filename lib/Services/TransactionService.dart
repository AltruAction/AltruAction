import 'package:cloud_functions/cloud_functions.dart';

class TransactionService {
  Future<void> createTransaction(
      String giverId, String receiverId, String itemId) async {
    final result = await FirebaseFunctions.instanceFor(region: 'asia-southeast1').httpsCallable('createTransaction').call({
      "giverId": giverId,
      "receiverId": receiverId,
      "itemId": itemId,
    });
  }
}
