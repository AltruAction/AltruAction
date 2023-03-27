import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(onPressed: () {
                FirebaseAuth.instance.signOut();
              }, child: const Text('settings', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Inter'))),
        const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30, fontFamily: 'Inter')),
        TextButton(onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'ReCloset',),
                ));
              }, child: const Text('logout', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Inter'))),
      ],
    )
  );
  }
}
