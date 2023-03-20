enum ItemCategory {
  tops,
  bottoms,
  dresses,
  outerwear,
  activewear,
  accessories,
  others
}

enum ItemSizes { xsMinus, xs, s, m, l, xl, xlPlus }

enum ItemTarget { male, female, unisex }

enum ItemCondition {
  none,
  brandNew,
  likeNew,
  lightlyUsed,
  wellUsed,
  heavilyUsed
}

enum ItemStatus { open, reserved, given }

enum ItemDealOption { delivery, meetup }

enum TransactionStatus { give, given, cancel }

class Transaction {
  int giverId;
  int receiverId;
  TransactionStatus status;

  Transaction(this.giverId, this.receiverId, this.status);
}

class Item {
  ItemCategory category;
  ItemSizes size;
  bool isChild;
  ItemTarget target;
  ItemCondition condition;
  String description;
  List<String> photoUrls;
  double longitude;
  double latitude;
  // id of users who like item
  List<int> likes;
  ItemStatus status;
  List<ItemDealOption> dealOptions;
  List<Transaction> transactions;

  Item(
      this.category,
      this.size,
      this.isChild,
      this.target,
      this.condition,
      this.description,
      this.photoUrls,
      this.latitude,
      this.longitude,
      this.likes,
      this.dealOptions,
      this.status,
      this.transactions);
}

class FilterState {
  late ItemCondition? condition;
  late int? minPrice;
  late int? maxPrice;
  late List<ItemDealOption> dealOptions;

  FilterState.empty() {
    condition = ItemCondition.none;
    minPrice = -1;
    maxPrice = -1;
    dealOptions = [];
  }

  FilterState(this.condition, this.dealOptions, this.maxPrice, this.minPrice);
}
