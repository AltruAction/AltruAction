import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recloset/Components/Category.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Data/Data.dart';
import 'package:recloset/Pages/CollectionPage.dart';
import 'package:recloset/Pages/Home.dart';
import 'package:recloset/Types/CommonTypes.dart';

class Categories extends StatefulWidget {
  final List<CategoryType> categories;

  const Categories({super.key, required this.categories});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
                          collection: DummyData.itemCardData,
                          title: c.categoryName)));
                },
                child: Category(
                  categoryName: c.categoryName,
                  imagePath: c.image,
                ));
          }).toList(),
        ));
  }
}
