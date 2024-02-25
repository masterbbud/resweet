import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/InfoManager.dart';

import '../main.dart';
import '../managers/EverythingManager.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  User myUser = nullUser;
  late bool dark;



  @override
  void initState() {
    super.initState();
    myUser = info.myUser;
    dark = AppState.of(context).getTheme() == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(15, 30, 0, 30),
        alignment: Alignment.topLeft,
        child: Text("Profile",
            style: TextStyle(
                fontFamily: 'BagelFatOne',
                fontSize: 48,
                color: Theme.of(context).colorScheme.onSecondary),
            textAlign: TextAlign.left),
      ),
      SizedBox(
        width: 150.0,
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  color: myUser.color,
                  borderRadius: BorderRadius.all(Radius.circular(75.0))),
              child: SizedBox(
                height: 150.0,
                width: 150.0,
                child: Center(
                    child: Text(myUser.getInitials(),
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 72,
                            color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
      Container(
          width: 400,
          child: Column(children: [
            Text(
              myUser.name,
              style: TextStyle(fontFamily: 'Inter', fontSize: 48),
              textAlign: TextAlign.center,
            )
          ])),
      Container(
          width: 400,
          child: Column(children: [
            Text(
              "@" + myUser.username,
              style: TextStyle(
                  fontFamily: 'Inter', fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            )
          ])),
      Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFF9F9F9),
          child: TextButton(
              onPressed: () {},
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit User Profile",
                      style: TextStyle(fontFamily: 'Inter', fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ]
                )
              ))),
      Container(
          alignment: Alignment.centerLeft,
          // margin: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          // color: Color(0xFFF9F9F9),
          child: TextButton(
              onPressed: () {setState(() {
                dark = !dark;
              });},
              child: SizedBox(
                height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Text(
                      "Toggle Dark Mode",
                      style: TextStyle(fontFamily: 'Inter', fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    Switch(
                      value: dark,
                      onChanged: (bool value) {
                        if (value)
                          AppState.of(context).changeTheme(ThemeMode.dark);
                        else
                          AppState.of(context).changeTheme(ThemeMode.light);
                        setState(() {
                          dark = value;
                        });
                      },
                    ),
                  ])))),
      Container(
          alignment: Alignment.centerLeft,
          // margin: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFF9F9F9),
          child: TextButton(
              onPressed: () {},
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(fontFamily: 'Inter', fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ]
                )
              ))),
      Container(
          alignment: Alignment.centerLeft,
          // margin: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          // color: Color(0xFFF9F9F9),
          child: TextButton(
              onPressed: () {},
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Sign out",
                  style: TextStyle(
                      fontFamily: 'Inter', fontSize: 20, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ))),
    ]));
  }
}
