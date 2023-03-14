import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ItemCard extends StatefulWidget {
  final String imagePath;
  final String name;
  final int credits;
  // final Function() onPress;

  const ItemCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.credits,
  }) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 200,
            width: 150,
            child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          widget.imagePath,
                          height: 140,
                          width: 140,
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${widget.credits} credits",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ))));
  }
}
