import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:recloset/Types/CommonTypes.dart';
import 'package:recloset/Types/UserTypes.dart';

class UserService {
  static var userDb = FirebaseFirestore.instance.collection("users");

  static Map<String, dynamic> toFirestore(UserState user) {
    return {
      "uuid": user.UUID,
      "credits": user.credits,
      "listedItems": user.listedItems,
      "likedItems": user.likedItems,
      "transactions": user.transactions
    };
  }

  static UserState fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    
    return UserState(
        data?['uuid'] ?? '', 
        data?['credits'] ?? 0,
        (data?['listedItems'] as List).map((item) => item as int).toList(),
        (data?['likedItems'] as List).map((item) => item as int).toList(),
        (data?['likedItems'] as List).map((item) => item as Transaction).toList()
    );
  }

  static Future<UserState?> createNewUser(String uuid) async {
    UserState? newUser = UserState(uuid, 0, [], [], []);
    final user = toFirestore(newUser);

    await userDb.doc(uuid).set(user).onError((error, stackTrace) => {
      newUser = null
    });

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
}
