import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/screens/NavBar.dart';


class PicturePage extends StatefulWidget {
  PicturePage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => PicturePageState();
  
}

class PicturePageState extends State<PicturePage> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SizedBox.expand(
            child: ColoredBox(
              color: Colors.grey),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: IconButton(iconSize: 70.0, color: Colors.white, icon: Icon(Icons.circle_outlined), onPressed: () {
                  loading = true;
                  api.processReceipt();
                },),
              )
            )
          )
        ]
      ),
    );

  }
}