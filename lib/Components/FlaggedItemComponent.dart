import 'package:flutter/material.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Services/ItemService.dart';

import '../Types/CommonTypes.dart';

class FlaggedItemComponent extends StatefulWidget {
  final  List<String> ids;
  const FlaggedItemComponent({Key? key, required this.ids}) : super(key: key);

  @override
  State<FlaggedItemComponent> createState() => _FlaggedItemComponentState();
}

class _FlaggedItemComponentState extends State<FlaggedItemComponent> {
  List<ItemCardData> _items = [];
  List<ItemCardData> _displayedItems = [];

  @override
  void initState() {
    super.initState();
    // Retrieve item records from Firestore
    getData();
  }

  void getData() async {
    var items = await ItemService().getFlaggedItems();
    setState(() {
      _items = items?.values.toList() ?? [];
      _displayedItems = _items.where((item) => widget.ids.contains(item.id) ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Collection(title: "Items under review", items: _displayedItems, showTitle: true, isFlaggedCollection: true,);
  }
}
