import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../MyHomePage.dart';
import '../Services/ItemService.dart';

class SuccessPage extends StatelessWidget {
  final Item item;
  final bool isOwner;
  const SuccessPage({Key? key, required this.item, required this.isOwner})
      : super(key: key);

  // Based on the estimation that one kg of cotton takes around 20,000 litres.
  // Weight from https://shippingstorm.com/en/list-of-weight/
  getAvgWater(String category) {
    int waterPerKg = 20000;
    switch (category.toLowerCase()) {
      case "accessories":
        return waterPerKg * 0.05;
      case "activewear":
        return waterPerKg * 0.2;
      case "bottoms":
        return waterPerKg * 0.2;
      case "dresses":
        return waterPerKg * 0.2;
      case "outerwear":
        return waterPerKg * 0.5;
      case "tops":
        return waterPerKg * 0.2;
      case "others":
        return waterPerKg * 0.1;
      default:
        return waterPerKg * 0.1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final startingText = isOwner
        ? "You have successfully given away"
        : "You are now the proud owner of";
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Congratulations!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                '$startingText\n "${item.name}"\n\nThis helped to save approximately ${NumberFormat('#,##,000').format(getAvgWater(item.category))} litres of water.\n\nThank you for doing your part to help the environment by reusing instead of buying new clothes.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
