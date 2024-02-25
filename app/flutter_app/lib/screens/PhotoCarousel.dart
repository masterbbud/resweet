import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoCarousel extends StatelessWidget {
  const PhotoCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 250),
      items: ['images/IMG_5301.jpg',
        'images/oh_yeah.png',
      'images/purin i quit.jpg'].map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container (
            width: 450,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.asset(i)
            )
          );
        }
      );
    }).toList()


    );
    throw UnimplementedError();
  }
  
}
  
