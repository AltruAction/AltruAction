import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recloset/MyHomePage.dart';
import 'package:recloset/services/UserService.dart';
import 'package:recloset/app_state.dart';

import '../Types/UserTypes.dart';

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
            Padding(
              padding: const EdgeInsets.all(20),
              child: GoogleSignInButton(
                  clientId: 'clientId',
                  loadingIndicator: const CircularProgressIndicator(),
                  onSignedIn: (UserCredential credential) {
                    handleSignIn(credential, context);
                  }),
            )
          ],
        ),
      ),
    );
  }

  handleSignIn(UserCredential credential, BuildContext context) async {
    final navigator = Navigator.of(context);
    await getOrCreateUser(credential.user!.uid, context);
    navigator.pop();
  }

  getOrCreateUser(String uuid, BuildContext context) async {
    final provider = Provider.of<ApplicationState>(context, listen: false);

    UserState? user;

    user = await UserService.getUser(uuid);

    user ??= await UserService.createNewUser(uuid);

    provider.updateUserState(user);
  }
}
