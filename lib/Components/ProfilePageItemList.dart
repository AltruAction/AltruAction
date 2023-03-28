import 'package:flutter/material.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Services/ItemService.dart';

import '../Types/CommonTypes.dart';

class ProfilePageItemList extends StatefulWidget {
  final  List<String> ids;
  const ProfilePageItemList({Key? key, required this.ids}) : super(key: key);

  @override
  State<ProfilePageItemList> createState() => _ProfilePageItemListState();
}

class _ProfilePageItemListState extends State<ProfilePageItemList> {
  List<ItemCardData> _items = [];
  List<ItemCardData> _displayedItems = [];

  @override
  void initState() {
    super.initState();
    // Retrieve item records from Firestore
    getData();
  }

  void getData() async {
    var items = await ItemService().getItems();
    setState(() {
      _items = items?.values.toList() ?? [];
      _displayedItems = _items.where((item) => widget.ids.contains(item.id) ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Collection(title: "", items: _displayedItems, showTitle: false);
  }
}
