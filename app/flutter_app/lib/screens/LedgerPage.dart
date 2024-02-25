import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/screens/NavBar.dart';

import '../managers/EverythingManager.dart';

class LedgerPage extends StatefulWidget {
  LedgerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LedgerPageState();
}

class LedgerPageState extends State<LedgerPage> {
  var totalSpending = 0.0;
  var groupMembers = [
    'Danil Donchuk',
    'Brandon Faunce',
    'Raynard Miot',
    'Jan Li'
  ];
  var dropdownValue;
  @override
  void initState() {
    super.initState();

    /**
     * Create method to get total spending here
     */
    totalSpending = 0.0;

    /**
     * Set group members here
     */
    groupMembers;
    dropdownValue = groupMembers.first;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(15, 30, 0, 30),
        alignment: Alignment.topLeft,
        child: Text("Ledger",
            style: TextStyle(
                fontFamily: 'BagelFatOne',
                fontSize: 48,
                color: Theme.of(context).colorScheme.onPrimary),
            textAlign: TextAlign.left),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
            child: const Text("Total spending\n(this week)",
                style: TextStyle(fontFamily: 'Inter', fontSize: 20))),
        Container(
          alignment: Alignment.topRight,
          child: Text("\$$totalSpending",
              style: const TextStyle(
                  fontFamily: "Inter", fontSize: 64, color: Colors.red)),
        )
      ]),
      Container(
          padding: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width - 100,
          child: DropdownButton<String>(
              isExpanded: true,
              style: const TextStyle(
                  fontFamily: "Inter", fontSize: 24, color: Colors.black),
              value: dropdownValue,
              items: groupMembers.map<DropdownMenuItem<String>>((i) {
                return DropdownMenuItem<String>(child: Text(i), value: i);
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              }))
    ]));
  }
}
