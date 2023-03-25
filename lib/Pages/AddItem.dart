import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recloset/Components/AddPhotoCollection.dart';
import 'package:recloset/Components/ChooseCategory.dart';
import 'package:recloset/Components/ChooseCondition.dart';

import '../Components/AddPhoto.dart';
import '../Data/ListingProvider.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _secondCategorySelected = <String>[];
  final List<String> _dealOptionSelected = <String>[];
  List<String> tags = [
    "Tops",
    "Bottoms",
    "Dresses",
    "Outerwear",
    "Activewear",
    "Accessories",
    "Others"
  ];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Scaffold(
                body: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                const AddPhotoCollection(title: "Add details"),
                const Text(
                  "Tap to edit photos. Drag and drop to reorder.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 82, 82, 82),
                  ),
                ),
                const Text(
                  "Category",
                  textAlign: TextAlign.left,
                ),
                const ChooseCategory(items: [
                  'TShirts & Polo Shirts',
                  'Pants',
                  'Dresses',
                  'Shorts'
                ]),
                const Text(
                  "Listing Title",
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name your listing',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Wrap(
                  spacing: 5.0,
                  children: tags.map((String tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: _secondCategorySelected.contains(tag),
                      onSelected: (bool value) {
                        setState(() {
                          if (value) {
                            if (!_secondCategorySelected.contains(tag)) {
                              _secondCategorySelected.add(tag);
                            }
                          } else {
                            _secondCategorySelected.removeWhere((String name) {
                              return name == tag;
                            });
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const Text("About the item",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text(
                  "Condition",
                  textAlign: TextAlign.left,
                ),
                const ChooseCondition(items: [
                  'Brand new',
                  'Like new',
                  'Lightly used',
                  'Well used',
                  'Heavily used'
                ]),

                // TODO: add price/tokens/wtv in the future
                // const Text(
                //   "Price",
                //   textAlign: TextAlign.left,
                // ),
                // TextFormField(
                //   controller: priceController,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     hintText: 'Name your listing',
                //   ),
                //   validator: (String? value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter some text';
                //     }
                //     return null;
                //   },
                // ),
                const Text(
                  "Description",
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Describe what you want to list',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),

                const Text(
                  "Deal Method",
                  textAlign: TextAlign.left,
                ),
                Wrap(
                  spacing: 5.0,
                  children: ["Meet up", "Delivery"].map((String tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: _dealOptionSelected.contains(tag),
                      onSelected: (bool value) {
                        setState(() {
                          if (value) {
                            if (!_dealOptionSelected.contains(tag)) {
                              _dealOptionSelected.add(tag);
                            }
                          } else {
                            _dealOptionSelected.removeWhere((String name) {
                              return name == tag;
                            });
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var db = FirebaseFirestore.instance;
                        var listing = Provider.of<ListingProvider>(context,
                            listen: false);
                        final item = {
                          "category": listing.category,
                          "condition": listing.condition,
                          "secondCategory": _secondCategorySelected,
                          "dealOption": _dealOptionSelected,
                          "description": descriptionController.text,
                          "images":
                              listing.items.map((e) => e.image.path).toList(),
                          "title": titleController.text,
                        };
                        db.collection("items").doc().set(item).onError(
                            (e, _) => print("Error writing document: $e"));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Listing Successful!')),
                        );
                      }
                    },
                    child: const Text('List it!'))
              ],
            ))));
  }
}
