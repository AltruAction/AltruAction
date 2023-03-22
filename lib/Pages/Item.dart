import 'package:flutter/material.dart';
import 'package:recloset/Components/Carousel.dart';
import 'package:flutter/services.dart';

import '../utils/utils.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class Item extends StatefulWidget {
  final int id;

  const Item({Key? key, required this.id});

  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  late final String name;
  late final List<String> imageUrls;
  late final int credits;
  late final int likes;
  late final String condition;
  late final String target;
  late final String category;
  late final String description;
  late final String location;
  late final String status;
  late final List<String> dealOption;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO call api to get details
    name = "White Top";
    imageUrls = imgList;
    credits = 1;
    likes = 3;
    condition = convertToUserFriendly("LIKE_NEW");
    target = convertToUserFriendly("MALE");
    category = convertToUserFriendly("TOPS");
    description = "This is a regular, human, non-stolen shirt.";
    location = "Woodlands";
    status = convertToUserFriendly("OPEN");
    dealOption = List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(shrinkWrap: true, children: [
      Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Carousel(imageUrls: imgList)),
      const Text(
        'Title',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 10),
              Text('Week Posted'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.monetization_on),
              SizedBox(width: 10),
              Text('Credits'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.thumb_up),
              SizedBox(width: 10),
              Text('Likes'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: 10),
              Text('Status'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.category),
              SizedBox(width: 10),
              Text('Category'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.description),
              SizedBox(width: 10),
              Text('Description'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.check_circle),
              SizedBox(width: 10),
              Text('Condition'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 10),
              Text('Gender'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 10),
              Text('Location'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.info_outline),
              SizedBox(width: 10),
              Text('Status'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.local_offer),
              SizedBox(width: 10),
              Text('Deal Options'),
            ],
          ),
        ],
      )
    ]));
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
