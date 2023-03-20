import 'package:flutter/material.dart';
import 'package:recloset/Components/Categories.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Components/FilterModal.dart';
import 'package:recloset/Components/SearchBar.dart';
import 'package:recloset/Types/CommonTypes.dart';
import "CollectionPage.dart";

void showFilterModal(BuildContext context, Function setState) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: FilterModal(
            onApply: (newState) {
              setState(newState);
            },
          ));
    },
  );
}

class CategoryType {
  String image;
  String categoryName;

  CategoryType(this.image, this.categoryName);
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<CategoryType> categories = [
    CategoryType("assets/shirt.png", "Tops"),
    CategoryType("assets/shirt.png", "Bottoms"),
    CategoryType("assets/shirt.png", "Dresses"),
    CategoryType("assets/shirt.png", "Outerwear"),
    CategoryType("assets/shirt.png", "Activewear"),
    CategoryType("assets/shirt.png", "Accessories"),
    CategoryType("assets/shirt.png", "Others"),
  ];

  static List<ItemCardData> dummyData = [
    ItemCardData(0, "White shirt", "assets/shirt.png", 10,
        ItemCondition.brandNew, [ItemDealOption.delivery]),
    ItemCardData(1, "Blue shirt", "assets/shirt.png", 5,
        ItemCondition.heavilyUsed, [ItemDealOption.meetup]),
    ItemCardData(
        2,
        "Green shirt",
        "assets/shirt.png",
        7,
        ItemCondition.lightlyUsed,
        [ItemDealOption.meetup, ItemDealOption.delivery]),
    ItemCardData(3, "Yellow shirt", "assets/shirt.png", 4,
        ItemCondition.likeNew, [ItemDealOption.delivery]),
    ItemCardData(4, "Orange shirt", "assets/shirt.png", 9,
        ItemCondition.wellUsed, [ItemDealOption.meetup]),
    ItemCardData(
        5,
        "Purple shirt",
        "assets/shirt.png",
        2,
        ItemCondition.brandNew,
        [ItemDealOption.meetup, ItemDealOption.delivery]),
  ];

  var _searchValue = "";
  var _items = dummyData;
  var filterState = FilterState.empty();

  void filter(ItemCardData items) {
    var filtered = _items;
    if (filterState.condition != ItemCondition.none) {
      filtered = filtered
          .where((element) => element.condition == filterState.condition)
          .toList();
    }

    if (filterState.minPrice != null && filterState.minPrice! >= 0) {
      filtered = filtered
          .where((element) => element.credits >= filterState.minPrice!)
          .toList();
    }

    if (filterState.minPrice != null && filterState.minPrice! >= 0) {
      filtered = filtered
          .where((element) => element.credits >= filterState.minPrice!)
          .toList();
    }

    if (filterState.maxPrice != null && filterState.maxPrice! >= 0) {
      filtered = filtered
          .where((element) => element.credits >= filterState.maxPrice!)
          .toList();
    }

    // add filter for item deal option
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Row(children: [
          Expanded(
              flex: 8,
              child: SearchBar(
                hintText: 'Search',
                onChanged: (value) {
                  // Do something with the search query
                  setState(() {
                    _searchValue = value;
                  });
                },
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CollectionPage(
                      collection: dummyData,
                      title: "Search Results",
                      isSearch: true,
                      searchQuery: _searchValue,
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      showFilterModal(context, (newState) {
                        filterState = newState;
                        print(filterState);
                      });
                    },
                    child: const Icon(Icons.filter_list),
                  )))
        ]),
        Categories(categories: categories),
        Collection(title: "For you", items: _items),
        Collection(title: "Following", items: _items),
        Collection(title: "Dresses", items: _items),
        Collection(title: "Bottoms", items: _items),
      ],
    ));
  }
}
