import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recloset/Components/AddPhotoCollection.dart';
import 'package:recloset/Components/ChooseCategory.dart';
import 'package:recloset/Components/ChooseCondition.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recloset/Services/LocationService.dart';
import 'package:http/http.dart' as http;
import 'package:recloset/MyHomePage.dart';
import 'package:recloset/Pages/Home.dart';

import '../Data/ListingProvider.dart';
import '../Types/CommonTypes.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

const double SPACING = 10;

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _secondCategorySelected = <String>[];
  String _clothesSize = "s";
  String _target = "Male";
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
  final creditsController = TextEditingController();
  final locationController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
  }
  
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
                const SizedBox(height: SPACING),
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
                const SizedBox(height: SPACING),
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
                const SizedBox(height: SPACING),
                const Text("About the item",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: SPACING),
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
                const SizedBox(height: SPACING),
                const Text(
                  "Size",
                  textAlign: TextAlign.left,
                ),
                Wrap(
                  spacing: 5.0,
                  children: ["XS--", "XS", "S", "M", "L", "XL", "XL++"]
                      .map((String selectedSize) {
                    return FilterChip(
                      label: Text(selectedSize),
                      selected: _clothesSize == selectedSize,
                      onSelected: (bool value) {
                        setState(() {
                          if (value) {
                            _clothesSize = selectedSize;
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: SPACING),
                const Text(
                  "Credits",
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: creditsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Amount of credits you want to list',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: SPACING),
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
                const SizedBox(height: SPACING),
                const Text(
                  "Target",
                  textAlign: TextAlign.left,
                ),
                Wrap(
                  spacing: 5.0,
                  children:
                      ["Male", "Female", "Unisex"].map((String selectedSize) {
                    return FilterChip(
                      label: Text(selectedSize),
                      selected: _target == selectedSize,
                      onSelected: (bool value) {
                        setState(() {
                          if (value) {
                            _target = selectedSize;
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: SPACING),
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
                const SizedBox(height: SPACING),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        // var db = FirebaseFirestore.instance;
                        var listing = Provider.of<ListingProvider>(context,
                            listen: false);

                        final item = {
                          "status": "OPEN",
                          "category": listing.category,
                          "condition": listing.condition,
                          "dealOption": _dealOptionSelected,
                          "description": descriptionController.text,
                          "images":
                              listing.items.map((e) => e.image).toList(),
                          "title": titleController.text,
                          "credits": int.tryParse(creditsController.text) ?? 0,
                          "size": _clothesSize,
                          "latitude": LocationService.position ?? -1,
                          "longitude": LocationService.position ?? -1,
                          // TODO: in production, uncomment this
                          // "owner": FirebaseAuth.instance.currentUser!.uid,
                          "timestamp": DateTime.now().millisecondsSinceEpoch,
                          "target": _target,
                        };
                        
                        // Create multipart request
                        var request = http.MultipartRequest('POST', Uri.parse("https://asia-southeast1-recloset-99e15.cloudfunctions.net/checkImage"));
                        request.fields['status'] = "OPEN";
                        request.fields['category'] = listing.category;
                        request.fields['condition'] = listing.condition;
                        request.fields['dealOption'] = _dealOptionSelected.map((dealOption) => '"$dealOption"').toList().toString();
                        request.fields['description'] = descriptionController.text;
                        request.fields['title'] = titleController.text;
                        request.fields['credits'] = creditsController.text;
                        request.fields['size'] = _clothesSize;
                        request.fields['location'] = locationController.text;
                        request.fields['owner'] = FirebaseAuth.instance.currentUser!.uid;
                        request.fields['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
                        request.fields['target'] = _target;

                        print(request.fields);
                        // Add each image from listing.items into the request
                        final images = listing.items.map((e) => e.image).toList();
                        for (final image in images) {
                          final stream = http.ByteStream(Stream.castFrom(image.openRead()));
                          final length = await image.length();

                          final multipartFile = http.MultipartFile('images', stream, length,
                              filename: image.path.split('/').last);

                          request.files.add(multipartFile);
                        }

                        // Send the request
                        try {
                          final response = await request.send();  
                          final responseBody = await response.stream.bytesToString();
                          final responseData = await jsonDecode(responseBody);

                          // Check the response status
                          if (response.statusCode == 200) {
                            if (responseData.containsKey('message')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(responseData['message'])),
                              );
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Something went wrong!'))
                              );
                            }
                          } else {
                            if (responseData.containsKey('error')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(responseData['error'])),
                              );
                              return;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Something went wrong!'))
                              );
                            }
                          }
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Something went wrong!')),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: _isLoading
                    ? CircularProgressIndicator() // Show loading indicator when _isLoading is true
                    : const Text('List it!'))
              ],
            ))));
  }
}
