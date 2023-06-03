import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ItemCard extends StatefulWidget {
  final String imagePath;
  final String name;
  final int credits;
  final bool isImageHidden;

  const ItemCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.credits,
    this.isImageHidden = false,
  }) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  Image _getImage(String imagePath) {
    Image defaultImage = Image.asset("assets/placeholder.png");
    Image image = defaultImage;
    if (!widget.isImageHidden && imagePath != "") {
      try {
        image = Image(image: NetworkImage(imagePath));
        return image;
      } catch (e) {
        print(e);
        return defaultImage;
      }
    } else {
      return defaultImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 200,
            width: 150,
            child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: const Color.fromARGB(10, 0, 0, 0))),
                            child: FadeInImage(
                              placeholder: Image.asset(
                                "assets/placeholder.png",
                              ).image,
                              image: _getImage(widget.imagePath).image,
                              width: 140,
                              height: 140,
                            ))),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${widget.credits} credit${widget.credits > 1 ? "s" : ""}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ))));
  }
}
