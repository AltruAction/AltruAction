import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfilePageName extends StatefulWidget {
  final String displayName;
  final String bio;

  const ProfilePageName({
    Key? key,
    required this.displayName,
    required this.bio,
  }) : super(key: key);

  @override
  State<ProfilePageName> createState() => _ProfilePageNameState();
}

class _ProfilePageNameState extends State<ProfilePageName> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        Text(widget.bio, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
      ],
    );
  }
}
