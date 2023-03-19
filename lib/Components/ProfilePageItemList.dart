import 'package:flutter/material.dart';
import 'package:recloset/Components/Collection.dart';

class ProfilePageItemList extends StatefulWidget {
  const ProfilePageItemList({Key? key}) : super(key: key);

  @override
  State<ProfilePageItemList> createState() => _ProfilePageItemListState();
}

class _ProfilePageItemListState extends State<ProfilePageItemList> {

  final List<ItemCardData> dummyData = [
    ItemCardData(0, "White shirt", "assets/shirt.png", 10),
    ItemCardData(1, "Blue shirt", "assets/shirt.png", 5),
    ItemCardData(2, "Green shirt", "assets/shirt.png", 7),
    ItemCardData(3, "Yellow shirt", "assets/shirt.png", 4),
    ItemCardData(4, "Orange shirt", "assets/shirt.png", 9),
    ItemCardData(5, "Purple shirt", "assets/shirt.png", 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Collection(title: "", items: dummyData, showTitle: false);
  }
}
