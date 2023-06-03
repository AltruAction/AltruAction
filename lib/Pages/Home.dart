import 'package:flutter/material.dart';
import 'package:recloset/Components/Categories.dart';
import 'package:recloset/Components/Collection.dart';
import 'package:recloset/Components/FilterModal.dart';
import 'package:recloset/Components/SearchBar.dart';
import 'package:recloset/Services/ItemService.dart';
import 'package:recloset/Types/CommonTypes.dart';
import "CollectionPage.dart";
import 'package:recloset/Services/LocationService.dart';
import 'package:geolocator/geolocator.dart';

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
  ItemCategory category;

  CategoryType(this.image, this.category);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _searchValue = "";
  List<ItemCardData> _items = [];
  List<ItemCardData> _displayedItems = [];
  var filterState = FilterState.empty();

  @override
  void initState() {
    super.initState();
    // Retrieve item records from Firestore
    getData();
    if (LocationService.position == null) {
      LocationService.determinePosition().then((_) => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location successfully detected!')),
            )
          });
    }
  }

  void getData() async {
    var items = await ItemService().getItems();
    setState(() {
      _items = items?.values.toList() ?? [];
      _displayedItems = _items;
    });
  }

  static List<CategoryType> categories = [
    CategoryType("assets/shirt.png", ItemCategory.tops),
    CategoryType("assets/pants.png", ItemCategory.bottoms),
    CategoryType("assets/dress.png", ItemCategory.dresses),
    CategoryType("assets/outerwear.png", ItemCategory.outerwear),
    CategoryType("assets/activewear.png", ItemCategory.activewear),
    CategoryType("assets/gloves.png", ItemCategory.accessories),
    CategoryType("assets/others.png", ItemCategory.others),
  ];

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

    // filter elements out whose distance exceeds max distance
    filtered = filtered.where((element) {
      if (element.latitude == null || element.longitude == null) {
        return true;
      }
      double bearing = Geolocator.bearingBetween(
          element.latitude ?? 0,
          element.longitude ?? 0,
          LocationService.position?.latitude ?? 0,
          LocationService.position?.longitude ?? 0);
      return bearing.abs() <= filterState.distance;
    }).toList();

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

  List<ItemCardData> filterCategory(
      List<ItemCardData> items, ItemCategory category) {
    var filtered = items;
    return filtered.where((element) => element.category == category).toList();
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
                      collection: _items,
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
                      }, () {
                        setState(() {
                          filterState = FilterState.empty();
                          _displayedItems = _items;
                        });
                      });
                    },
                    child: const Icon(Icons.filter_list),
                  )))
        ]),
        Categories(categories: categories),
        Collection(title: "For you", items: _displayedItems),
        ...ItemCategory.values.map((e) {
          var categoryItems = filterCategory(_displayedItems, e);
          if (categoryItems.isNotEmpty) {
            return Collection(title: e.displayName, items: categoryItems);
          } else {
            // display nothing
            return const SizedBox.shrink();
          }
        })
      ],
    ));
  }
}
