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
  List<User> groupMembers = [];
  List<List<PaymentSpec>> paymentSpecs = [];
  var dropdownValue;

  int getIndexByUser(User user) {
    for (int i = 0; i < groupMembers.length; i++) {
      if (groupMembers[i].uuid == user.uuid) {
        return i;
      }
    }
    return -1;
  }

  List<PaymentSpec> getSpecByName(String name) {
    User ?user;
    for (User u in groupMembers) {
      if (u.name == name) {
        user = u;
      }
    }
    if (user == null) {
      return [];
    }
    return paymentSpecs[getIndexByUser(user!)];
  }

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
    groupMembers = info.allUsers;
    dropdownValue = groupMembers.first.name;

    paymentSpecs = [];
    for (User u in groupMembers) {
      paymentSpecs.add([]);
    }

    for (Receipt r in info.myReceipts) {
      if (r.assignee.uuid == info.myUser.uuid) {
        for (int u = 0; u < groupMembers.length; u++) {
          if (groupMembers[u].uuid != info.myUser.uuid) {
            paymentSpecs[u].add(PaymentSpec(
                name: r.name,
                date: r.date,
                price: r.getPriceForUser(groupMembers[u])));
            totalSpending += r.getPriceForUser(groupMembers[u]);
          }
        }
      } else {
        paymentSpecs[getIndexByUser(r.assignee)].add(PaymentSpec(
            name: r.name,
            date: r.date,
            price: -1 * r.getPriceForUser(info.myUser)));
        totalSpending -= r.getPriceForUser(info.myUser);
      }
    }
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
            child: const Text("Total owed",
                style: TextStyle(fontFamily: 'Inter', fontSize: 20))),
        Container(
          alignment: Alignment.topRight,
          child: Text((totalSpending < 0 ? "-" : "+")+"\$"+totalSpending.abs().toStringAsFixed(2),
              style: TextStyle(
                  fontFamily: "Inter", fontSize: 64, color: totalSpending < 0 ? Colors.red : Colors.green)),
        )
      ]),
      Container(
          padding: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width - 100,
          child: DropdownButton<String>(
              isExpanded: true,
              style: const TextStyle(
                  fontFamily: "Inter", fontSize: 24),
              value: dropdownValue,
              items: groupMembers.map<DropdownMenuItem<String>>((i) {
                return DropdownMenuItem<String>(child: Text(i.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),), value: i.name);
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              })),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 100,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: getSpecByName(dropdownValue).length,
              itemBuilder: (BuildContext context, int index) {
                PaymentSpec ps = getSpecByName(dropdownValue)[index];
                return Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(ps.name),
                    Text(ps.date)
                  ],),
                  Spacer(),
                  Text((ps.price < 0 ? "-" : "+")+"\$"+ps.price.abs().toStringAsFixed(2), style: TextStyle(color: ps.price < 0 ? Colors.red : Colors.green))
                ],);
              },
            )
          ),
        )
    ]));
  }
}

class PaymentSpec {
  final String name;
  final String date;
  final double price;

  PaymentSpec({required this.name, required this.date, required this.price});
}
