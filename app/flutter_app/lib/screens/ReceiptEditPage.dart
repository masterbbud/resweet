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

  TextEditingController nameController = TextEditingController(text: '');

  List<String> groupNames = [];
  String dropdownValue = "";
  
  void initState() {
    groupNames = info.allUsers.map((u) => u.name).toList();
    dropdownValue = groupNames.first;
  }

  User getUserByName(String name) {
    for (User u in info.allUsers) {
      if (u.name == name) {
        return u;
      }
    }
    return info.allUsers.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox.expand(
              child: Column(
                  children: [
                    Text("Edit Receipt"),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.receipt.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ReceiptItem(receipt: widget.receipt.items[index]);
                          },
                        ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(children: [
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 40,
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Name your purchase',
                                  hintText: 'Name'
                                ),
                              ),
                            ),
                            Spacer()
                          ],),
                        ),
                        Row(children: [
                          Spacer(),
                          Text("Who's paying?"),
                          SizedBox(
                            width: 300,
                            height: 40,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              style: const TextStyle(
                                  fontFamily: "Inter", color: Colors.black),
                              value: dropdownValue,
                              items: groupNames.map<DropdownMenuItem<String>>((i) {
                                return DropdownMenuItem<String>(
                                    child: Text(i), value: i);
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              }),
                          ),
                          Spacer()
                        ],),
                        Row(children: [
                          Spacer(),
                          Checkbox(
                            checkColor: Colors.black,
                            fillColor: MaterialStateProperty.resolveWith((states) {
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
                        ],),
                        TextButton(
                          onPressed: () {
                            api.confirmReceipt(widget.receipt, nameController.text, getUserByName(dropdownValue)).then((receipt) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReceiptAssignmentPage(receipt: receipt)),
                              );
                            });
                            
                          },
                          child: Text("Confirm")
                        ),
                    ],)
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
    costController = TextEditingController(text: widget.receipt.price.toString());
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 100,
            child: TextField(
              controller: nameController,
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
    );
  }
}
