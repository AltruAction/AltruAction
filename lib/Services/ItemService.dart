import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Types/CommonTypes.dart';

class Item {
  late final String name;
  late final List<String> imageUrls;
  late final int credits;
  late final int likes;
  late final String condition;
  late final String target;
  late final String category;
  late final String description;
  late final String location;
  late final String status;
  late final String dealOptions;
  late final String date;
  late final String owner;

  Item.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data()! as Map<String, dynamic>;
    name = data['name'];
    imageUrls = List<String>.from(data['imageUrls']);
    credits = data['credits'];
    likes = data['likes'];
    condition = data['condition'];
    target = data['target'];
    category = data['category'];
    description = data['description'];
    location = data['location'];
    status = data['status'];
    dealOptions = data['dealOptions'];
    date = data['date'];
    owner = data['owner'];
  }
}

// reference: https://medium.com/google-developer-experts/firestore-database-flutter-38c9a0cc77c
class ItemService {
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

  Future<Item> getDocumentById(String id) async {
    final doc = await db.collection('items').doc(id).get();
    final item = Item.fromSnapshot(doc);
    return item;
  }

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
