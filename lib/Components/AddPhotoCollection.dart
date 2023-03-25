import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:recloset/Components/ItemCard.dart';
import 'package:recloset/Data/ListingProvider.dart';
import 'package:recloset/Extensions/map.dart';

import 'AddPhoto.dart';

class ItemCardData {
  // TODO: Change to UUID?
  int id;
  String name;
  String imagePath;
  int credits;

  ItemCardData(this.id, this.name, this.imagePath, this.credits);
}

class AddPhotoCollection extends StatefulWidget {
  final String title;
  const AddPhotoCollection({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<AddPhotoCollection> createState() => _AddPhotoCollectionState();
}

class _AddPhotoCollectionState extends State<AddPhotoCollection> {
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
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          Consumer<ListingProvider>(
            builder: (context, listings, child) {
              return SizedBox(
                  height: 200,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [for (var i = 0; i < 10; i += 1) i]
                          .mapIndexed((e, index) => AddPhoto(index: index))
                          .toList()));
            },
          )
        ]));
  }
}
