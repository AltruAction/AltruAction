import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final String imagePath;
  final String categoryName;

  const Category(
      {Key? key, required this.imagePath, required this.categoryName})
      : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: 100,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          widget.imagePath,
                          height: 50,
                          width: 50,
                        )))),
            Text(widget.categoryName)
          ],
        ));
  }
}
