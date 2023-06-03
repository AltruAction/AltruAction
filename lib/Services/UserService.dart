import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:recloset/Types/CommonTypes.dart';
import 'package:recloset/Types/UserTypes.dart';

class UserService {
  static var userDb = FirebaseFirestore.instance.collection("users");
  static var itemDb = FirebaseFirestore.instance.collection("items");

  static Map<String, dynamic> toFirestore(UserState user) {
    return {
      "uuid": user.UUID,
      "credits": user.credits,
      "listedItems": user.listedItems,
      "flaggedItems": user.flaggedItems,
      "likes": user.likes,
      "transactions": user.transactions,
      "email": user.email,
    };
  }

  static UserState fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return UserState(
        data?['uuid'] ?? '',
        data?['credits'] ?? 0,
        (data?['listedItems'] as List).map((item) => item as String).toList(),
        (data?['flaggedItems'] as List).map((item) => item as String).toList(),
        (data?['likes'] as List).map((item) => item as String).toList(),
        (data?['transactions'] as List)
            .map((item) => item as Transaction)
            .toList(),
        data?['email'] ?? '',);
  }

  static Future<UserState?> createNewUser(String uuid, String email) async {
    UserState? newUser =
        UserState(uuid, 0, [], [], [], [], email);
    final user = toFirestore(newUser);
    await userDb
        .doc(uuid)
        .set(user)
        .onError((error, stackTrace) => {newUser = null});

    return newUser;
  }

  static Future<UserState?> getUser(String uuid) async {
    try {
      UserState? res;
      await userDb.doc(uuid).get().then((event) {
        if (event.data() != null) {
          res = fromFirestore(event);
        }
      });
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> updateLikeItem(String uuid, String itemId, bool isLike) async {
    List<Future> futures;
    if (isLike) {
      futures = [
        userDb.doc(uuid).update({ "likes": FieldValue.arrayUnion([itemId])}),
        itemDb.doc(itemId).update({ "likes": FieldValue.arrayUnion([uuid])})
      ];
    } else {
      futures = [
        userDb.doc(uuid).update({ "likes": FieldValue.arrayRemove([itemId])}),
        itemDb.doc(itemId).update({ "likes": FieldValue.arrayRemove([uuid])})
      ];
    }

    await Future.wait(futures);
  }
}
