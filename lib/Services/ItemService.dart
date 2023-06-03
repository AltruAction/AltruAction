import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Types/CommonTypes.dart';

class Item {
  late final String name;
  late final List<String> imageUrls;
  late final int credits;
  late final List<String> likes;
  late final String condition;
  late final String target;
  late final String category;
  late final String description;
  late final String location;
  late final String status;
  late final List<String> dealOptions;
  late final int date;
  late final String owner;
  late final String size;

  Item.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data()! as Map<String, dynamic>;
    name = data['title'] ?? "";

    imageUrls = data['images'] == null
        ? List.empty()
        : List<String>.from(data['images']);
    print(imageUrls);
    credits = data['credits'] ?? 0;
    likes = data['likes'] == null ? [] : List<String>.from(data['likes']);
    condition = data['condition'] ?? "";
    target = data['target'] ?? "";
    category = data['category'] ?? "";
    description = data['description'] ?? "";
    location = data['location'] ?? "";
    status = data['status'] ?? "";
    dealOptions = data['dealOption'] == null
        ? List.empty()
        : List<String>.from(data['dealOption']);
    date = data['timestamp'] ?? 0;
    owner = data['owner'] ?? "";
    size = data['size'] ?? "";
  }
}

// reference: https://medium.com/google-developer-experts/firestore-database-flutter-38c9a0cc77c
class ItemService {
  // TODO: Refactor from singleton?
  static var db = FirebaseFirestore.instance;

  Future<Item> getItemById(String id) async {
    final doc = await db.collection('items').doc(id).get();
    // print(doc.data());
    final item = Item.fromSnapshot(doc);
    print(item);
    return item;
  }
  
  Future<Map<String, ItemCardData>?> getItems() async {
    try {
      Map<String, ItemCardData> result = {};
      await db.collection("items").get().then((event) {
        for (var doc in event.docs) {
          var data = doc.data();
          print(data);
          List<dynamic> dataDealOptions = data["dealOption"];
          List<dynamic>? images = data["images"];

          var newEntry = ItemCardData(
              doc.id,
              data["title"] ?? "",
              images != null && images.isNotEmpty && images[0] != null
                  ? images[0]
                  : "",
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
          newEntry.latitude = data["latitude"];
          newEntry.longitude = data["longitude"];
          result[doc.id] = newEntry;
        }
      });
      print(result);
      return result;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String, ItemCardData>?> getFlaggedItems() async {
    try {
      Map<String, ItemCardData> result = {};
      await db.collection("flaggedItems").get().then((event) {
        for (var doc in event.docs) {
          var data = doc.data();
          print(data);
          List<dynamic> dataDealOptions = data["dealOption"];
          List<dynamic>? images = data["images"];

          var newEntry = ItemCardData(
              doc.id,
              data["title"] ?? "",
              images != null && images.isNotEmpty && images[0] != null
                  ? images[0]
                  : "",
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
      print(result);
      return result;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Item> getFlaggedItemById(String id) async {
    final doc = await db.collection('flaggedItems').doc(id).get();
    // print(doc.data());
    final item = Item.fromSnapshot(doc);
    print(item);
    return item;
  }
}
