import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/screens/NavBar.dart';


class ReceiptEditPage extends StatefulWidget {
  ReceiptEditPage({Key? key, required this.receipt}) : super(key: key);
  Receipt receipt;
  
  @override
  State<StatefulWidget> createState() => ReceiptEditPageState();
  
}

class ReceiptEditPageState extends State<ReceiptEditPage> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Column(children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.receipt.items.length,
            itemBuilder: (BuildContext context, int index) {
              return ReceiptItem(receipt: widget.receipt.items[index]);
            },
          )
        ],)
      ],)
      
    );

  }
}

class ReceiptItem extends StatefulWidget {
  final Receipt receipt;

  ReceiptItem({required this.receipt});
  
  @override
  State<StatefulWidget> createState() => ReceiptItemState();
}

class ReceiptItemState extends State<ReceiptItem> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
  
}
