import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/screens/NavBar.dart';


class LedgerPage extends StatefulWidget {
  LedgerPage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => LedgerPageState();
  
}

class LedgerPageState extends State<LedgerPage> {
  @override
  Widget build(BuildContext context) {
    return Text("Test");
  }
}