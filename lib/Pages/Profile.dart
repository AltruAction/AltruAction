import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:recloset/Components/AchievementCard.dart';
import 'package:recloset/Components/ProfilePageHeader.dart';
import 'package:recloset/Components/ProfilePageName.dart';
import 'package:recloset/Components/ProfilePicture.dart';
import 'package:recloset/Pages/login.dart';
import 'package:recloset/Types/UserTypes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recloset/services/UserService.dart';

import '../Components/ProfilePageItemList.dart';
import '../app_state.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<AchievementCard> achievementArray = [];

  void handleGivingAchievements() {
    String uuid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (uuid == "") {
      return;
    }

    FirebaseFirestore.instance
        .collection("transactions")
        .where('giverId', isEqualTo: uuid)
        .count()
        .get()
        .then((res) {
      if (res.count > 0 && res.count < 10) {
        achievementArray.add(const AchievementCard(
            title: "Green Giver",
            description:
                "Congrats! You have given your first item away in the name of sustainability!",
            imagePath: "assets/greenAchievement.png"));
      } else if (res.count > 10 && res.count < 100) {
        achievementArray.add(const AchievementCard(
            title: "Eco-Pioneer",
            description: "Gave 10 items",
            imagePath: "assets/achievement.png"));
      } else if (res.count > 100) {
        achievementArray.add(const AchievementCard(
            title: "Sustainability Trailblazer",
            description: "Gave 100 items",
            imagePath: "assets/achievement.png"));
      }

      if (res.count > 0) {
        achievementArray.add(AchievementCard(
            title: "Planet Protector",
            description:
                "You have saved ${2400 * res.count} litres of water by giving away ${res.count} item(s)! Keep up the good work!",
            imagePath: "assets/waterAchievement.png"));
      }
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
      }
    });
    String? uuid =
        Provider.of<ApplicationState>(context, listen: false).user?.uid;
    if (uuid != null) {
      fetchAndUpdateUserState(uuid);
    }

    handleGivingAchievements();

    super.initState();
  }

  fetchAndUpdateUserState(String uuid) async {
    final provider = Provider.of<ApplicationState>(context, listen: false);

    provider.updateIsFetchingUserState(true);

    UserState? user = await UserService.getUser(uuid);
    provider.updateUserState(user);
    provider.updateIsFetchingUserState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ApplicationState>(builder: (context, appState, _) {
        if (appState.user == null || appState.isFetchingUserState) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(scrollDirection: Axis.vertical, children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const ProfilePageHeader(),
              Positioned(
                  top: 100,
                  child: ProfilePicture(
                      imagePath:
                          'https://api.dicebear.com/6.x/fun-emoji/png?seed=${Provider.of<ApplicationState>(context, listen: false).user?.uid}'))
            ],
          ),
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 75),
              child: ProfilePageName(
                  displayName: appState.user?.displayName ?? "",
                  bio: "Save the Earth!")),
          Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 25),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0.9,
                          blurRadius: 10,
                          blurStyle: BlurStyle.inner)
                    ]),
                labelColor: Colors.green,
                tabs: const [
                  Tab(text: "Listings"),
                  Tab(text: "Liked"),
                  Tab(text: "Statistics"),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              )),
          SizedBox(
              height: 400,
              child: Center(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(
                        child: ProfilePageItemList(
                            ids: appState.userState?.listedItems ?? [])),
                    Center(
                        child: ProfilePageItemList(
                            ids: appState.userState?.likes ?? [])),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: achievementArray),
                    // const [
                    //   AchievementCard(
                    //       title: "this is a great achievement",
                    //       description: "donated more than 10 items",
                    //       imagePath: "assets/achievement.png"),
                    //   AchievementCard(
                    //       title: "this is a great achievement",
                    //       description: "donated more than 10 items",
                    //       imagePath: "assets/achievement.png"),
                    // ]
                  ],
                ),
              )),
        ]);
      }),
    );
  }
}
