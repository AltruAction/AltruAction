import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Components/ItemCard.dart';

class CollectionPage extends StatefulWidget {
  final List<ItemCardData> collection;

  const CollectionPage({
    Key? key,
    required this.collection,
  }) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      scrollDirection: Axis.vertical,
      children: [
        Text("collectionName"),
        GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            children: widget.collection
                .map((item) => ItemCard(
                    imagePath: item.imagePath,
                    name: item.name,
                    credits: item.credits))
                .toList())
      ],
    ));
  }
}
