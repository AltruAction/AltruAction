import 'package:flutter/material.dart';

class FlaggedItemBottomNavigationBar extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback onAccept;

  const FlaggedItemBottomNavigationBar({
    super.key,
    required this.onReject,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: onReject,
            child: const Text('Reject Item'),
          ),
          ElevatedButton(
            onPressed: onAccept,
            child: const Text('Accept Item'),
          ),
        ],
      ),
    );
  }
}
