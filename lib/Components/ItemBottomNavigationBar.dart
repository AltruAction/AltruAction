import 'package:flutter/material.dart';

class ItemBottomNavigationBar extends StatelessWidget {
  final bool isOwner;
  final bool liked;
  final int likes;
  final VoidCallback onLikePressed;
  final VoidCallback onShowContactInfoPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onGenerateQRCodePressed;
  final bool isGiven;

  ItemBottomNavigationBar(
      {required this.isOwner,
      required this.liked,
      required this.likes,
      required this.onLikePressed,
      required this.onShowContactInfoPressed,
      required this.onEditPressed,
      required this.onGenerateQRCodePressed,
      required this.isGiven});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (isOwner)
            TextButton(
              onPressed: onEditPressed,
              child: Text('Edit Listing'),
            )
          else
            Row(
              children: [
                IconButton(
                  onPressed: onLikePressed,
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.green : null,
                  ),
                ),
                Text('$likes'),
              ],
            ),
          ElevatedButton(
            onPressed: isGiven
                ? null
                : isOwner
                    ? onGenerateQRCodePressed
                    : onShowContactInfoPressed,
            child: Text(isOwner ? 'Generate QR Code' : 'Show Contact Info'),
          ),
        ],
      ),
    );
  }
}
