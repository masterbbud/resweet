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
            Icon(
              Icons.check_circle_outline_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.onPrimary
            ),
            Column(
              children: [
                Text("Done!",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary)),
                Text("Here are your totals:",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onPrimary)),
              ],
            ),
            Divider(),
            Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: ListView.builder(
                  itemCount: info.allUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: info.allUsers[index].color,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(info.allUsers[index].name,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onSurface)),
                            Spacer(),
                            Text(
                                '\$${receipt.getPriceForUser(info.allUsers[index]).toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onSurface))
                          ],
                        )
                    );
                  }),
            )),
            //SizedBox(height: 10),
            Row(
              children: [
                Text("Paid for by ${receipt.assignee.name}"),
                Spacer(),
                Text("\$${receipt.getTotal().toStringAsFixed(2)}")
              ],
            ),

            Spacer(),
            SizedBox(
              height: 40,
                child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Go home",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.background)),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(15, 10, 15, 10)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.onPrimary),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary)))),
            )),
          ],
        )),
      ),
    );
  }
}
