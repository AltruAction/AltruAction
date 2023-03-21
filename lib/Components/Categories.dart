import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recloset/Components/Category.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Pages/CollectionPage.dart';
import 'package:recloset/Pages/Home.dart';

class Categories extends StatefulWidget {
  final List<CategoryType> categories;

  const Categories({super.key, required this.categories});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
    return SizedBox(
        height: 100,
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: widget.categories.map((c) {
            return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CollectionPage(
                          collection: dummyData, title: c.categoryName)));
                },
                child: Category(
                  categoryName: c.categoryName,
                  imagePath: c.image,
                ));
          }).toList(),
        ));
  }
}
