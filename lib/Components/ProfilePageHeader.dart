import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recloset/Pages/CollectionPage.dart';
import 'package:recloset/Pages/FlaggedItemPage.dart';

import '../MyHomePage.dart';

class ProfilePageHeader extends StatelessWidget {
  const ProfilePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
  return Container(
    color: const Color.fromRGBO(93, 176, 117, 1),
    height: 200,
    padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'settings') {
                // Handle settings button press
                // Navigate to the settings page or show a settings dialog
              } else if (value == 'logout') {
                // Handle logout button press
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'settings',
                child: TextButton(onPressed: () {
                  FirebaseAuth.instance.signOut();
                }, child: const Text('Settings', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Inter'))),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: TextButton(onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
                }, child: const Text('Logout', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Inter'))),
              ),
              PopupMenuItem<String>(
                value: 'underreview',
                child: TextButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FlaggedItemPage(),
                  ));
                }, child: const Text('Items Under Review', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Inter'))),
              ),
            ],
          ),
        ],
      ),
  );
  }
}
