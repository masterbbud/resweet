import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/managers/InfoManager.dart';
import 'package:flutter_app/screens/NavBar.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  
  @override
  State<HomePage> createState() => HomePageState();

  
}

class HomePageState extends State<HomePage> {

  User myUser = nullUser;
  List<User> users = List<User>.empty();
  List<Transaction> transactions = List<Transaction>.empty();

  @override
  void initState() {
    super.initState();
    myUser = info.myUser;
    users = info.allUsers;
    transactions = [];
    for (Receipt r in info.myReceipts) {
      if (r.assignee != myUser) {
        double amount = 0;
        List<SubTransaction> items = [];
        for (RItem i in r.items) {
          if (i.payers.any((p) => p.uuid == myUser.uuid)) {
            double subamount = i.price / i.payers.length;
            items.add(SubTransaction(name: i.name, amt: subamount));
            amount += subamount;
          }
        }
        transactions.add(Transaction(date: r.date, from: r.assignee.name, amount: amount, name: r.name, items: items));
      }
      
    }
    transactions = transactions;
  } 

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Container (
              alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(15, 30, 0, 30),
                child: Text("Welcome "+myUser.name+"!",
                    style: TextStyle (
                        fontSize: 44,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontFamily: 'BagelFatOne'
                    )
                )
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = users[index];
                    return UserGroupIcon(user: user);
                  },
                ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final transaction = transactions[index];
                    return TransactionItem(transaction: transaction);
                  },
                ),
            ),
            Expanded(
              child: TextButton(onPressed: () {
                api.getYourReceipts();
              }, child: Text("Click")),
            )
          ],
        ),
      );

  }
}

class TransactionItem extends StatefulWidget {

  const TransactionItem({Key? key, required this.transaction}) : super(key: key);
  final Transaction transaction;
  
  @override
  State<StatefulWidget> createState() => TransactionItemState();
  
  
}

class TransactionItemState extends State<TransactionItem> {

  bool showItems = false;

  List<SubTransactionWidget> subItems = [];

  @override
  Widget build(BuildContext context) {
    final Color c = widget.transaction.amount < 0 ? Colors.red : Colors.green;
    final String text = widget.transaction.amount > 0 ? "Owes you \$" : "You owe \$";
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!showItems) {
                showItems = true;
                subItems = widget.transaction.items.map((e) => SubTransactionWidget(st: e)).toList();
              }
              else {
                showItems = false;
                subItems = [];
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(widget.transaction.date),
                Spacer(),
                Column(children: [
                  Text(widget.transaction.from),
                  Text(widget.transaction.name)
                ],),
                
                Spacer(),
                Text(text + widget.transaction.amount.abs().toString(), style: TextStyle(color: c))
              ],),
            ),
          ),
          ...subItems,
          Divider()
        ],),
      )
    );
  }
}

class SubTransactionWidget extends StatelessWidget {
  const SubTransactionWidget({super.key, required this.st});

  final SubTransaction st;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 4.0),
      child: Row(children: [
          Text(st.name),
          Spacer(),
          Text('\$${st.amt}')
        ]
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
            decoration: BoxDecoration(color: user.color, borderRadius: BorderRadius.all(Radius.circular(20.0))),
            
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

class Transaction {

  const Transaction({required this.date, required this.from, required this.amount, required this.name, required this.items});
  final String date;
  final String from;
  final double amount;
  final String name;
  final List<SubTransaction> items;
}

class SubTransaction {
  const SubTransaction({required this.name, required this.amt});

  final String name;
  final double amt;
}
