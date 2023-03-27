import 'package:flutter/material.dart';
import 'package:recloset/Components/Carousel.dart';
import 'package:flutter/services.dart';

import '../Components/ItemBottomNavigationBar.dart';
import '../utils/utils.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class ViewItem extends StatefulWidget {
  final String id;

  const ViewItem({Key? key, required this.id});

  @override
  State<StatefulWidget> createState() => _ViewItemState();
}

class _ViewItemState extends State<ViewItem> {
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
  late final String dealOptions;
  late final String date;

  @override
  void initState() {
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
    dealOptions = ["Meet Up", "Delivery"].join(', ');
    date = "22/02/2023";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(shrinkWrap: true, children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Carousel(imageUrls: imgList)),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            '$name',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('Posted on $date'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$credits'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$likes'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$status'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$category'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$condition'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$target'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$location'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.local_offer,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$dealOptions'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text('$description'),
                  ],
                ),
              ],
            )),
      ]),
      bottomNavigationBar: ItemBottomNavigationBar(
          isOwner: true,
          liked: true,
          likes: likes,
          onLikePressed: () => {},
          onShowContactInfoPressed: () => {},
          onEditPressed: () => {},
          onGenerateQRCodePressed: () => {}),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
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
