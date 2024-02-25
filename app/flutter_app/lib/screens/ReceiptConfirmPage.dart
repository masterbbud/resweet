import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/EverythingManager.dart';

class ReceiptConfirmPage extends StatelessWidget {
  ReceiptConfirmPage({Key? key, required this.receipt}) : super(key: key);
  Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: Column(
              children: [
                Spacer(),
                Text("Your receipt has been saved!"),
                Spacer(),
                Expanded(
                  child: ListView.builder(
                    itemCount: info.allUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(children: [
                        Text(info.allUsers[index].name),
                        Spacer(),
                        Text('\$${receipt.getPriceForUser(info.allUsers[index]).toStringAsFixed(2)}')
                      ],);
                    }),
                ),
                //SizedBox(height: 10),
                Row(children: [
                  Text("Paid for by ${receipt.assignee.name}"),
                  Spacer(),
                  Text("\$${receipt.getTotal().toStringAsFixed(2)}")
                ],),
                
                Spacer(),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: const Text("Go Home"))
              ],
            )
          ),
      ),
    );
  }
}