import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:recloset/MyHomePage.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
               padding: const EdgeInsets.all(20),
               child: Image.asset('assets/loginImage.png'),
            ),
            Padding(padding: const EdgeInsets.all(20),
              child: GoogleSignInButton(
                clientId: 'clientId',
                loadingIndicator: const CircularProgressIndicator(),
                onSignedIn: (UserCredential credential) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'ReCloset',),
                  ));
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
