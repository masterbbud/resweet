import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/screens/NavBar.dart';


class GroupPage extends StatefulWidget {
  GroupPage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => GroupPageState();
  
}

class GroupPageState extends State<GroupPage> {

  List<User> users = [];

  @override
  void initState() {
    super.initState();
    users = info.allUsers;
    print(users);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return UserItem(user: users[index]);
          },
        ),
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          DecoratedBox(
            decoration: BoxDecoration(color: user.color, borderRadius: BorderRadius.all(Radius.circular(40.0))),
            
            child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: Center(child: Text(user.getInitials(), style: TextStyle(fontSize: 35.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            child: Column(children: [
              Text(user.name, style: TextStyle(fontSize: 35.0)),
              Text('@${user.username}', style: TextStyle(fontSize: 15.0))
            ],
              crossAxisAlignment: CrossAxisAlignment.start
              ),
          )
        ],),
        SizedBox(height: 10)
      ],
    );
  }
}

