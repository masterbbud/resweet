import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/managers/InfoManager.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.selectFunc});

  final Function(int) selectFunc;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF4CC9F0),
      child: IconTheme(
          data: IconThemeData(color: Color(0xFFFFFFFF)),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 30,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onSecondary,
                        border: Border.all(width: 10, color: Colors.white)),
                    child: IconButton(
                      tooltip: 'Upload',
                      icon: const Icon(Icons.file_upload),
                      onPressed: () {selectFunc(1);},
                      iconSize: 37.74,
                      padding: const EdgeInsets.only(bottom: 0),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Home',
                    icon: const Icon(Icons.home_outlined),
                    onPressed: () {selectFunc(0);},
                    padding: const EdgeInsets.only(left: 30.0),
                    iconSize: 37.74,
                  ),
                  const Spacer(),
                  IconButton(
                      tooltip: 'Group',
                      icon: const Icon(Icons.group_outlined),
                      onPressed: () {selectFunc(2);},
                      iconSize: 37.74,
                      padding: const EdgeInsets.only(right: 70)),
                  IconButton(
                      tooltip: 'Ledger',
                      icon: const Icon(Icons.folder_outlined),
                      onPressed: () {selectFunc(3);},
                      iconSize: 37.74,
                      padding: const EdgeInsets.only(left: 70)),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Account',
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () {selectFunc(4);},
                    iconSize: 37.74,
                    padding: const EdgeInsets.only(right: 30.0),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
