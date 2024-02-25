import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/screens/NavBar.dart';
import 'package:flutter_app/screens/ReceiptConfirmPage.dart';

class ReceiptAssignmentPage extends StatefulWidget {
  ReceiptAssignmentPage({Key? key, required this.receipt}) : super(key: key);
  Receipt receipt;

  @override
  State<StatefulWidget> createState() => ReceiptAssignmentPageState();
}

class ReceiptAssignmentPageState extends State<ReceiptAssignmentPage> {
  bool loading = false;
  bool isChecked = true;

  int selectedUser = 0;

  Color darken(Color color, [double amount = .3]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
            child: SizedBox.expand(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Assign Items"),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.receipt.items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: ReceiptItem(receipt: widget.receipt.items[index], selectedUser: selectedUser)),
                                );
                              },
                            ),
                          Spacer(),
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  // TODO give everything with blank payers to the assignee
                                  api.finalizeReceipt(widget.receipt).then((receipt) {
                                    Navigator.pop(
                                      context,
                                    );
                                    Navigator.pop(
                                      context,
                                    );
                                    Navigator.pop(
                                      context,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ReceiptConfirmPage(receipt: receipt)),
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
                  SizedBox(
                    width: 100,
                    child: Expanded(
                      child: Container(
                        color: darken(info.allUsers[selectedUser].color),
                        child: Column(
                          children: [
                            Spacer(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: info.allUsers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          selectedUser = index;
                                          setState(() {});
                                        },
                                        child: UserGroupIcon(user: info.allUsers[index], selected: index == selectedUser)
                                      ),
                                      
                                      SizedBox(height: 10)
                                    ]
                                  );
                                },
                              ),
                            ),
                            Spacer(),
                          ],
                        )
                      ),),
                  )
                ],
              ),
            ),
          ),
    );
  }
}

class ReceiptItem extends StatefulWidget {
  final RItem receipt;
  final int selectedUser;

  ReceiptItem({required this.receipt, required this.selectedUser});

  @override
  State<StatefulWidget> createState() => ReceiptItemState();
}

class ReceiptItemState extends State<ReceiptItem> {

  void initState() {
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.receipt.payers.contains(info.allUsers[widget.selectedUser])) {
          widget.receipt.payers.remove(info.allUsers[widget.selectedUser]);
        }
        else {
          widget.receipt.payers.add(info.allUsers[widget.selectedUser]);
        }
        setState(() {});
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(widget.receipt.name),
                    ))
                ),
              ),
              SizedBox(
                  width: 100,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text('\$${widget.receipt.price}'),
                    ))
                ),
            ],
          ),
          Row(children: [
            Spacer(),
            SizedBox(
                  width: 226,
                  height: 28,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    itemCount: widget.receipt.payers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DecoratedBox(
                            
                            decoration: BoxDecoration(
                              color: widget.receipt.payers[index].color,
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                          
                              child: Text(""),
                          ),
                        )
                      );
                    },
                  ),
                ),
          ],),
          Divider()
        ],
      ),
    );
  }
}

class UserGroupIcon extends StatelessWidget {

  const UserGroupIcon({Key? key, required this.user, required this.selected}) : super(key: key);
  final User user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.0,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: user.color,
            border: () {
              if (selected) return Border.all(color: Colors.white, width: 2);
              else return Border.all(color: Colors.transparent, width: 0);}(),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            
            child: SizedBox(
              height: 40.0,
              width: 40.0,
              child: Center(child: Text(user.getInitials())),
            ),
          ),
        ],
      ),
    );
  }
}

