import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final CollectionReference _transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  Future<void> createTransaction(
      String giverId, String itemId, String receiverId) async {
    // Create new transaction document in the "transactions" collection
    final newTransactionDoc = _transactionsCollection.doc();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Add transaction data to the new document
      await transaction.set(newTransactionDoc, {
        'giverId': giverId,
        'itemId': itemId,
        'receiverId': receiverId,
        'status': 'COMPLETED',
      });

      // Update the status of the corresponding item document in the "items" collection to "GIVEN"
      final itemDoc = _itemsCollection.doc(itemId);
      final itemSnapshot = await transaction.get(itemDoc);
      if (itemSnapshot.exists) {
        await transaction.update(itemDoc, {'status': 'GIVEN'});
      }
    });
  }
}
