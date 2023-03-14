import 'package:flutter/material.dart';
import 'package:recloset/Components/Categories.dart';
import 'package:recloset/Components/Category.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Components/ItemCard.dart';
import 'package:recloset/Components/SearchBar.dart';

class CategoryType {
  String image;
  String categoryName;

  CategoryType(this.image, this.categoryName);
}

class Home extends StatelessWidget {
  final List<CategoryType> categories = [
    CategoryType("assets/shirt.png", "Tops"),
    CategoryType("assets/shirt.png", "Bottoms"),
    CategoryType("assets/shirt.png", "Dresses"),
    CategoryType("assets/shirt.png", "Outerwear"),
    CategoryType("assets/shirt.png", "Activewear"),
    CategoryType("assets/shirt.png", "Accessories"),
    CategoryType("assets/shirt.png", "Others"),
  ];

  final List<ItemCardData> dummyData = [
    ItemCardData(0, "White shirt", "assets/shirt.png", 10),
    ItemCardData(1, "Blue shirt", "assets/shirt.png", 5),
    ItemCardData(2, "Green shirt", "assets/shirt.png", 7),
    ItemCardData(3, "Yellow shirt", "assets/shirt.png", 4),
    ItemCardData(4, "Orange shirt", "assets/shirt.png", 9),
    ItemCardData(5, "Purple shirt", "assets/shirt.png", 2),
  ];

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        SearchBar(
          hintText: 'Search',
          onChanged: (value) {
            // Do something with the search query
            print('Search query: $value');
          },
        ),
        Categories(categories: categories),
        Collection(title: "For you", items: dummyData),
        Collection(title: "Following", items: dummyData),
        Collection(title: "Dresses", items: dummyData),
        Collection(title: "Bottoms", items: dummyData),
      ],
    ));
  }
}
