import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/screens/NavBar.dart';


class PicturePage extends StatefulWidget {
  PicturePage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => PicturePageState();
  
}

class PicturePageState extends State<PicturePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            child: ColoredBox(
              color: Colors.grey),
          ),
          Positioned(
            left: 100.0,
            top: 100.0,
            child: IconButton(icon: Icon(Icons.circle_outlined), onPressed: () {},)
          )
        ]
      ),
    );

  }
}