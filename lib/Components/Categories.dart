import 'package:flutter/material.dart';
import 'package:recloset/Components/Category.dart';
import 'package:recloset/Data/Data.dart';
import 'package:recloset/Pages/CollectionPage.dart';
import 'package:recloset/Pages/Home.dart';

import '../DatabaseService.dart';
import '../Types/CommonTypes.dart';
import 'Collection.dart';

class Categories extends StatefulWidget {
  final List<CategoryType> categories;

  const Categories({super.key, required this.categories});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<ItemCardData> _items = [];
  var filterState = FilterState.empty();

  @override
  void initState() {
    super.initState();
    // Retrieve item records from Firestore
    getData();
  }

  void getData() async {
    var items = await DatabaseService().getItems();
    setState(() {
      _items = items?.values.toList() ?? [];
    });
  }

  List<ItemCardData> filterCategory(
      List<ItemCardData> items, ItemCategory category) {
    var filtered = items;
    return filtered.where((element) => element.category == category).toList();
  }

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
                          collection: filterCategory(_items, c.category),
                          title: c.category.displayName)));
                },
                child: Category(
                  categoryName: c.category.displayName,
                  imagePath: c.image,
                ));
          }).toList(),
        ));
  }
}
