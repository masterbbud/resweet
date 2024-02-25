import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 75,
        width: 75,
        child: FittedBox (
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          shape: CircleBorder(),

          child: Icon(Icons.upload, size: 37.74,color: Colors.white,),
        )),

      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        color: Theme.of(context).colorScheme.onPrimary,

        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Spacer(),
                  IconButton(
                    tooltip: 'Home',
                    icon: const Icon(Icons.home_outlined),
                    onPressed: () {},
                    iconSize: 37.74,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Group',
                    icon: const Icon(Icons.group_outlined),
                    onPressed: () {},
                    iconSize: 37.74,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Ledger',
                    icon: const Icon(Icons.folder_outlined),
                    onPressed: () {},
                    iconSize: 37.74,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Account',
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () {},
                    iconSize: 37.74,
                    color: Colors.white,
                  ),
                  const Spacer(),
                ],
              ),
      ),
    );
  }
}
