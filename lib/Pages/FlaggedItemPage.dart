import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recloset/Components/FlaggedItemComponent.dart';
import 'package:recloset/Components/ProfilePageItemList.dart';

import '../app_state.dart';

class FlaggedItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Consumer<ApplicationState>(builder: (context, appState, _) {
        if (appState.user == null || appState.isFetchingUserState) {
          return const Center(child: CircularProgressIndicator());
        }
        print(appState.userState?.flaggedItems ?? []);
        return FlaggedItemComponent(ids: appState.userState?.flaggedItems ?? []);
      })
    );
  }
}