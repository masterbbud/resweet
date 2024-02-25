import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/screens/NavBar.dart';
import 'package:flutter_app/screens/ReceiptAssignmentPage.dart';

class ReceiptEditPage extends StatefulWidget {
  ReceiptEditPage({Key? key, required this.receipt}) : super(key: key);
  ReceiptSnapshot receipt;

  @override
  State<StatefulWidget> createState() => ReceiptEditPageState();
}

class ReceiptEditPageState extends State<ReceiptEditPage> {
  bool loading = false;
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox.expand(
            child: Column(
              children: [
                Container(
                    color: Colors.transparent,
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.fromLTRB(15, 30, 0, 10),
                    child: Text("Edit Receipt",
                        style: TextStyle(
                            fontSize: 44,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontFamily: 'BagelFatOne'))),
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  child: Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.receipt.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ReceiptItem(
                            receipt: widget.receipt.items[index]);
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Checkbox(
                          checkColor: Colors.black,
                          fillColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context).colorScheme.onSecondary;
                            }
                            return Colors.white;
                          }),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text("Include Tax with item prices"),
                        Spacer()
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child:TextButton(
                        onPressed: () {
                          api.confirmReceipt(widget.receipt).then((receipt) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReceiptAssignmentPage(receipt: receipt)),
                            );
                          });
                        },
                        child: Text("Confirm",
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
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReceiptItem extends StatefulWidget {
  final RSItem receipt;

  ReceiptItem({required this.receipt});

  @override
  State<StatefulWidget> createState() => ReceiptItemState();
}

class ReceiptItemState extends State<ReceiptItem> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController costController = TextEditingController(text: '');

  void initState() {
    nameController = TextEditingController(text: widget.receipt.desc);
    costController =
        TextEditingController(text: widget.receipt.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 100,
                child: TextField(
                  controller: nameController,
                  clipBehavior: Clip.none,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Item',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: TextField(
                controller: costController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                ),
              ),
            ),
          ],
        ));
  }
}
