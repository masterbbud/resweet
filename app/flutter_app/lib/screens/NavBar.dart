
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.green,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            children: <Widget>[
              IconButton(
                tooltip: 'Home',
                icon: const Icon(Icons.home_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Group',
                icon: const Icon(Icons.group_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Camera',
                icon: const Icon(Icons.add_a_photo_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Ledger',
                icon: const Icon(Icons.folder_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Account',
                icon: const Icon(Icons.account_circle_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
  }
}