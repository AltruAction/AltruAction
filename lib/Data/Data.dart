import '../Components/Collection.dart';
import '../Types/CommonTypes.dart';

class Store {
  static Store store = new Store();
}

class DummyData {
  static List<ItemCardData> itemCardData = [
    ItemCardData("0", "White shirt", "assets/placeholder.jpg", 10,
        ItemCondition.brandNew, [ItemDealOption.delivery], ItemCategory.tops),
    ItemCardData("1", "Blue shirt", "assets/placeholder.jpg", 5,
        ItemCondition.heavilyUsed, [ItemDealOption.meetup], ItemCategory.tops),
    ItemCardData(
        "2",
        "Green shirt",
        "assets/placeholder.jpg",
        7,
        ItemCondition.lightlyUsed,
        [ItemDealOption.meetup, ItemDealOption.delivery],
        ItemCategory.tops),
    ItemCardData("3", "Yellow shirt", "assets/placeholder.jpg", 4,
        ItemCondition.likeNew, [ItemDealOption.delivery], ItemCategory.tops),
    ItemCardData("4", "Orange shirt", "assets/placeholder.jpg", 9,
        ItemCondition.wellUsed, [ItemDealOption.meetup], ItemCategory.tops),
    ItemCardData(
        "5",
        "Purple shirt",
        "assets/placeholder.jpg",
        2,
        ItemCondition.brandNew,
        [ItemDealOption.meetup, ItemDealOption.delivery],
        ItemCategory.tops),
  ];
}
