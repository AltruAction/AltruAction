import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recloset/Components/Carousel.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recloset/Services/ItemService.dart';
import 'package:recloset/Types/UserTypes.dart';
import 'package:recloset/app_state.dart';
import 'package:recloset/services/UserService.dart';
import '../Components/FlaggedItemBottomNavigationBar.dart';
import '../utils/utils.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class ViewFlaggedItem extends StatefulWidget {
  final String id;

  const ViewFlaggedItem({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _ViewFlaggedItemState();
}

class _ViewFlaggedItemState extends State<ViewFlaggedItem> {
  String name = "";
  List<String> imageUrls = List.empty();
  int credits = 0;
  List<String> likes = [];
  String condition = "";
  String target = "";
  String category = "";
  String description = "";
  String location = "";
  String status = "";
  String dealOptions = "";
  DateTime date = DateTime.now();
  String owner = "";
  String email = "";
  String size = "";
  String current_user = "";

  void showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    getData();
    super.initState();
  }

  getData() async {
    Item item = await ItemService().getFlaggedItemById(widget.id);
    UserState? user = await UserService.getUser(item.owner);
    setState(() {
      name = item.name;
      imageUrls = item.imageUrls;
      credits = item.credits;
      likes = item.likes;
      condition = convertToUserFriendly(item.condition);
      target = convertToUserFriendly(item.target);
      category = convertToUserFriendly(item.category);
      description = item.description;
      location = item.location;
      status = convertToUserFriendly(item.status);
      dealOptions = item.dealOptions.join(', ');
      date = DateTime.fromMillisecondsSinceEpoch(item.date);
      owner = item.owner;
      email = user?.email ?? "";
      size = item.size;
      current_user = FirebaseAuth.instance.currentUser!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(shrinkWrap: true, children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Carousel(imageUrls: imageUrls)),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text('Posted on ${date.day}/${date.month}/${date.year}'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text('$credits'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(likes.length.toString()),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.info,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(status),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.category,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(category),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(condition),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(target),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.straighten,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(size),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(location),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.handshake,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(dealOptions),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        description,
                        maxLines: 100,
                        overflow: TextOverflow
                            .ellipsis, // Change to the type of overflow you want
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ]),
      bottomNavigationBar:
          Consumer<ApplicationState>(builder: (context, appState, _) {
        String? uid = appState.user?.uid;
        return FlaggedItemBottomNavigationBar(
          onAccept: () async {
            final doc = await FirebaseFirestore.instance
                .collection('flaggedItems')
                .doc(widget.id)
                .get();
            final data = doc.data();

            if (data != null) {
              // Copy the flagged item to the items collection
              await FirebaseFirestore.instance.collection('items').add(data);

              // Delete the flagged item from the flaggedItems collection
              await FirebaseFirestore.instance
                  .collection('flaggedItems')
                  .doc(widget.id)
                  .delete();

              // Show a success notification
              showNotification('Item accepted successfully');

              // Navigate back to the previous page
              Navigator.of(context).pop();
            } else {
              // Handle the case when the flagged item doesn't exist
              showNotification('Item not found');
            }
          },
          onReject: () async {
            // Delete the flagged item from the flaggedItems collection
            await FirebaseFirestore.instance
                .collection('flaggedItems')
                .doc(widget.id)
                .delete();

            // Show a notification
            showNotification('Item rejected successfully');

            // Navigate back to the previous page
            Navigator.of(context).pop();
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  isOwner(String? uuid) {
    if (uuid != null) {
      return uuid == owner;
    }
    return false;
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

class ChatScreen {}
