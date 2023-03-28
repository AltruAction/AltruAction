import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recloset/Services/ItemService.dart';

class TransactionService {
  final CollectionReference _transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createTransaction(
      String giverId, String receiverId, String itemId) async {
    if (giverId == receiverId) {
      throw 'Cannot transact with self';
    }

    // Start a Firestore transaction
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final itemSnapshot = await _itemsCollection.doc(itemId).get();
      if (!itemSnapshot.exists) {
        throw 'Item does not exist';
      }
      final itemData = itemSnapshot.data()! as Map<String, dynamic>;
      int itemCredits = itemData["credits"] ?? 0;
      String status = itemData['status'] ?? "";
      if (status == "GIVEN") {
        throw 'Item has already been given';
      }

      // Get the giver and receiver user documents and check that they exist
      final giverSnapshot = await _usersCollection.doc(giverId).get();
      if (!giverSnapshot.exists) {
        throw 'Giver does not exist';
      }

      final receiverSnapshot = await _usersCollection.doc(receiverId).get();
      if (!receiverSnapshot.exists) {
        throw 'Receiver does not exist';
      }

      final giverData = giverSnapshot.data()! as Map<String, dynamic>;
      final recieverData = receiverSnapshot.data()! as Map<String, dynamic>;

      // Check that the receiver has enough credits to transfer
      final int receiverCredits = recieverData['credits'] ?? 0;
      if (receiverCredits < itemCredits) {
        throw 'Transaction failed: receiver does not have enough credits';
      }

      // Subtract the item credits from the receiver and add them to the giver
      final int giverCredits = giverData['credits'] ?? 0;

      transaction.update(_usersCollection.doc(giverId),
          {'credits': giverCredits + itemCredits});
      transaction.update(_usersCollection.doc(receiverId),
          {'credits': receiverCredits - itemCredits});

      // Add transaction data to the new document
      final newTransactionDoc = _transactionsCollection.doc();
      await transaction.set(newTransactionDoc, {
        'giverId': giverId,
        'itemId': itemId,
        'receiverId': receiverId,
        'status': 'COMPLETED',
      });

      // Update the item status to 'GIVEN'
      transaction.update(_itemsCollection.doc(itemId), {'status': 'GIVEN'});
    });
  }
}
