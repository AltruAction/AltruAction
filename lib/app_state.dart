import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'Types/UserTypes.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  User? _user;
  User? get user => _user;
  UserState? _userState;
  UserState? get userState => _userState;
  bool _isFetchingUserState = false;
  bool get isFetchingUserState => _isFetchingUserState;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _user = user;
      } else {
        _loggedIn = false;
        _user = null;
      }
      notifyListeners();
    });
  }

  void updateUserState(UserState? user) {
    _userState = user;
    notifyListeners();
  }

  void updateIsFetchingUserState(bool isFetchingUserState) {
    _isFetchingUserState = isFetchingUserState;
    notifyListeners();
  }
}