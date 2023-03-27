import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;
  const Header({super.key, required this.text});
  static const headerTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsetsDirectional.only(top: 20, bottom: 20),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: headerTextStyle,
            )));
  }
}
