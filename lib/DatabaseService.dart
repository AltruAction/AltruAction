import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Types/CommonTypes.dart';

// reference: https://medium.com/google-developer-experts/firestore-database-flutter-38c9a0cc77c7

class DatabaseService {
  // TODO: Refactor from singleton?
  static var db = FirebaseFirestore.instance;
  // Future<String?> addUser({
  //   required String fullName,
  //   required String age,
  //   required String email,
  // }) async {
  //   try {
  //     CollectionReference users =
  //         FirebaseFirestore.instance.collection('users');
  //     // Call the user's CollectionReference to add a new user
  //     await users.doc(email).set({
  //       'full_name': fullName,
  //       'age': age,
  //     });
  //     return 'success';
  //   } catch (e) {
  //     return 'Error adding user';
  //   }
  // }

  Future<Map<String, ItemCardData>?> getItems() async {
    try {
      Map<String, ItemCardData> result = Map();
      await db.collection("items").get().then((event) {
        print(event.docs);
        for (var doc in event.docs) {
          var data = doc.data();
          List<dynamic> dataDealOptions = data["dealOption"];
          List<dynamic>? images = data["images"];

          var newEntry = ItemCardData(
              doc.id,
              data["title"],
              images != null && images.isNotEmpty ? data["images"][0] : "",
              data["credits"] ?? 1,
              ItemCondition.values.firstWhere(
                  (element) =>
                      element.toString() ==
                      "ItemCondition.${data['condition']}",
                  orElse: () => ItemCondition.none),
              dataDealOptions
                  .map((e) => ItemDealOption.values.firstWhere(
                      (element) => element.toString() == "ItemDealOption.$e",
                      orElse: () => ItemDealOption.none))
                  .toList(),
              ItemCategory.values.firstWhere(
                  (element) =>
                      element.toString() == "ItemCategory.${data["category"]}",
                  orElse: () => ItemCategory.others));
          result[doc.id] = newEntry;
        }
      });
      return result;
    } catch (e) {
      print(e);
      return Map();
    }
  }
}
