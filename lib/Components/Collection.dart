import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recloset/Components/ItemCard.dart';
import 'package:recloset/Pages/CollectionPage.dart';

class ItemCardData {
  // TODO: Change to UUID?
  int id;
  String name;
  String imagePath;
  int credits;

  ItemCardData(this.id, this.name, this.imagePath, this.credits);
}

class Collection extends StatefulWidget {
  final String title;
  final List<ItemCardData> items;
  const Collection({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 30),
                  )),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CollectionPage(
                          collection: widget.items,
                          title: widget.title,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "More",
                    style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline),
                  ))
            ],
          ),
          SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.items
                    .map((item) => ItemCard(
                        imagePath: item.imagePath,
                        name: item.name,
                        credits: item.credits))
                    .toList(),
              ))
        ]));
  }
}
