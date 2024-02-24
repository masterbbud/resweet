import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/screens/NavBar.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title, required this.users, required this.transactions, required this.myUser}) : super(key: key);
  final String title;

  final User myUser;
  final List<User> users;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      body: Center(
        child: Column(
          children: [
            Text("Welcome "+myUser.name),
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
          ],
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {

  const TransactionItem({Key? key, required this.transaction}) : super(key: key);
  final Transaction transaction;


  @override
  Widget build(BuildContext context) {
    final Color c = transaction.amount < 0 ? Colors.red : Colors.green;
    final String text = transaction.amount > 0 ? "Owes you \$" : "You owe \$";
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Text(transaction.date),
              Spacer(),
              Text(transaction.from),
              Spacer(),
              Text(text + transaction.amount.abs().toString(), style: TextStyle(color: c))
            ],),
          ),
          Divider()
        ],),
      )
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

  const Transaction({required this.date, required this.from, required this.amount});
  final String date;
  final String from;
  final int amount;
}
