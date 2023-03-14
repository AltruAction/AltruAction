import 'package:flutter/material.dart';
import 'package:recloset/Components/Categories.dart';
import 'package:recloset/Components/Category.dart';
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
        Categories(categories: categories)
      ],
    ));
  }
}
