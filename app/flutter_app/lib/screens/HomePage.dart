import 'package:flutter/material.dart';
import 'package:flutter_app/screens/NavBar.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title, required this.users}) : super(key: key);
  final String title;

  final List<User> users;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      body: Center(
        child: Column(
          children: [
            Text("Welcome USER"),
            Row(
              children: [
                ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return UserGroupIcon(user: User(color: Colors.red, name: "Brandon Faunce"));
                  },
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class UserGroupIcon extends StatelessWidget {

  const UserGroupIcon({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.0,
      child: Column(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(20.0))),
            
            child: SizedBox(
              height: 40.0,
              width: 40.0,
              child: Center(child: Text(user.getInitials())),
            ),
          ),
          Text(user.name, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}

class User {

  const User({required this.name, required this.color});
  final String name;
  final Color color;

  String getInitials() {
    return name.split(' ').map((e) => e[0].toUpperCase()).toList().join("");
  }
}