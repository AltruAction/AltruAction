import 'package:flutter/material.dart';
import 'package:recloset/Components/Carousel.dart';
import 'package:flutter/services.dart';

class Item extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(shrinkWrap: true, children: [
      Container(
          height: MediaQuery.of(context).size.height * 0.3, child: Carousel()),
      Text((MediaQuery.of(context).size.height * 0.3).toString())
    ]));
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
