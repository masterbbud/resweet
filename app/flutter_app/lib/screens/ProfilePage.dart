import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/screens/NavBar.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => ProfilePageState();
  
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Text("Test");
  }
}