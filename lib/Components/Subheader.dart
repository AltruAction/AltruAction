import 'package:flutter/material.dart';

class Subheader extends StatelessWidget {
  final String text;
  const Subheader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black54),
        ));
  }
}
