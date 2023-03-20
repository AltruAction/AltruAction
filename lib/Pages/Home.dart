import 'package:flutter/material.dart';
import 'package:recloset/Components/Categories.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Components/FilterModal.dart';
import 'package:recloset/Components/SearchBar.dart';
import 'package:recloset/Data/Data.dart';
import 'package:recloset/Types/CommonTypes.dart';
import "CollectionPage.dart";

void showFilterModal(BuildContext context, FilterState filterState,
    Function setState, void Function() reset) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: FilterModal(
              filterState: filterState,
              onApply: (newState) {
                setState(newState);
              },
              onClear: reset));
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

  var _searchValue = "";
  final _items = DummyData.itemCardData;
  var _displayedItems = DummyData.itemCardData;
  var filterState = FilterState.empty();

  List<ItemCardData> filter(List<ItemCardData> items) {
    var filtered = items;

    // filter out elements by chosen condition
    if (filterState.condition != ItemCondition.none) {
      filtered = filtered
          .where((element) => element.condition == filterState.condition)
          .toList();
    }

    // filter elements out whose credits exceed min price
    if (filterState.minPrice != null && filterState.minPrice! >= 0) {
      filtered = filtered
          .where((element) => element.credits >= filterState.minPrice!)
          .toList();
    }

    // filter elements out whose credits exceed max price
    if (filterState.maxPrice != null && filterState.maxPrice! >= 0) {
      filtered = filtered
          .where((element) => element.credits <= filterState.maxPrice!)
          .toList();
    }

    // add filter for item deal option if deal options were chosen
    filtered = filtered.where((element) {
      if (filterState.dealOptions.isNotEmpty) {
        var chosenSet = filterState.dealOptions.toSet();
        var intersection = chosenSet.intersection(element.dealOptions.toSet());
        return intersection.isNotEmpty;
      } else {
        return true;
      }
    }).toList();

    return filtered;
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
                      collection: DummyData.itemCardData,
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
                      showFilterModal(context, filterState, (newState) {
                        setState(() {
                          filterState = newState;
                          _displayedItems = filter(_items);
                        });
                        print(filterState.condition);
                        print(filterState.minPrice);
                        print(filterState.maxPrice);
                        print(filterState.dealOptions);
                      }, () {
                        print("Check clear");
                        setState(() {
                          filterState = FilterState.empty();
                          _displayedItems = _items;
                          print(filterState.condition);
                          print(filterState.minPrice);
                          print(filterState.maxPrice);
                          print(filterState.dealOptions);
                        });
                      });
                    },
                    child: const Icon(Icons.filter_list),
                  )))
        ]),
        Categories(categories: categories),
        Collection(title: "For you", items: _displayedItems),
        Collection(title: "Following", items: _displayedItems),
        Collection(title: "Dresses", items: _displayedItems),
        Collection(title: "Bottoms", items: _displayedItems),
      ],
    ));
  }
}
