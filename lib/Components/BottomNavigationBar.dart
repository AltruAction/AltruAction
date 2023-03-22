import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppNavigationBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<AppNavigationBar> createState() => AppNavigationBarState();
}

class AppNavigationBarState extends State<AppNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Entry',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.face),
          label: 'Profile',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.green[300],
      onTap: widget.onItemTapped,
    );
  }
}
