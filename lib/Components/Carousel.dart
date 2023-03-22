import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/src/widgets/framework.dart';

class Carousel extends StatefulWidget {
  final List<String> imageUrls;

  const Carousel({super.key, required this.imageUrls});

  @override
  State<StatefulWidget> createState() {
    return _CarouselState();
  }
}

class _CarouselState extends State<Carousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late List<Widget> imageSliders;

  @override
  void initState() {
    imageSliders = widget.imageUrls
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      ],
                    )),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Container(
          // transform: Matrix4.translationValues(0.0, -70, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageUrls.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.green)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        )
      ]),
    );
  }
}
