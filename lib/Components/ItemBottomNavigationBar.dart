import 'package:flutter/material.dart';

class ItemBottomNavigationBar extends StatelessWidget {
  final bool isOwner;
  final bool liked;
  final int likes;
  final VoidCallback onLikePressed;
  final VoidCallback onShowContactInfoPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onGenerateQRCodePressed;
  final VoidCallback onChatPressed;

  final bool isGiven;

  const ItemBottomNavigationBar(
      {super.key,
      required this.isOwner,
      required this.liked,
      required this.likes,
      required this.onLikePressed,
      required this.onChatPressed,
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
              child: const Text('Edit Listing'),
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
          if (!isOwner)
            ElevatedButton(
              onPressed: isGiven ? null : onChatPressed,
              child: const Text('Chat'),
            ),
        ],
      ),
    );
  }
}
