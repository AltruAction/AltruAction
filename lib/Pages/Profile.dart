import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recloset/Pages/login.dart';

import '../app_state.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loggedIn) ...[
                  const Text('I am logged in'),
                  TextButton(onPressed: () {
                    FirebaseAuth.instance.signOut();
                  }, child: const Text('logout'))
                ],
                if (!appState.loggedIn) ... [
                  const Text('I am not logged in'),
                  TextButton(onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Login(),
              )); }, child: const Text('login'))
                ]
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}
