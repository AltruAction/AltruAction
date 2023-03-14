import 'package:flutter/material.dart';
import 'package:recloset/Components/BottomNavigationBar.dart';
import 'package:recloset/Pages/QrCodeScanner.dart';

import './Pages/Profile.dart';
import './Pages/Home.dart';
import './Pages/AddItem.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

TextStyle getOptionStyle() {
  return TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    Home(),
    AddItem(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar not needed
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Open QR Code Scanner',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const QrCodeScanner(),
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: AppNavigationBar(
        onItemTapped: (int idx) {
          _onItemTapped(idx);
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
