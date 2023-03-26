import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String imagePath;

  const ProfilePicture({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

  return CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(imagePath, scale: 1),
                ),
    );
  }
}
