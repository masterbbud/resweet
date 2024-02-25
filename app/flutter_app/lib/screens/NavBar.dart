import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.selectFunc});

  final Function(int) selectFunc;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Scaffold (

        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 75,
          width: 75,
          child: FittedBox (
              child: FloatingActionButton(
                onPressed: () {selectFunc(1);},
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
                onPressed: () {selectFunc(0);},
                iconSize: 37.74,
                color: Colors.white,
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Group',
                icon: const Icon(Icons.group_outlined),
                onPressed: () {selectFunc(2);},
                iconSize: 37.74,
                color: Colors.white,),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              IconButton(
                tooltip: 'Ledger',
                icon: const Icon(Icons.folder_outlined),
                onPressed: () {selectFunc(3);},
                iconSize: 37.74,
                color: Colors.white,),
              const Spacer(),
              IconButton(
                tooltip: 'Account',
                icon: const Icon(Icons.account_circle_outlined),
                onPressed: () {selectFunc(4);},
                iconSize: 37.74,
                color: Colors.white,
              ),
              const Spacer(),
            ],
          ),
        ),
      )
    );
  }
}
