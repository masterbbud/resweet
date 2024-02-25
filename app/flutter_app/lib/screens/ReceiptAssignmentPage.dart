import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/managers/ApiManager.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/screens/NavBar.dart';

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
                                return ReceiptItem(receipt: widget.receipt.items[index]);
                              },
                            ),
                          Spacer(),
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ReceiptAssignmentPage(receipt: widget.receipt)),
                                  );
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
                                        child: UserGroupIcon(user: info.allUsers[index])
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

  ReceiptItem({required this.receipt});

  @override
  State<StatefulWidget> createState() => ReceiptItemState();
}

class ReceiptItemState extends State<ReceiptItem> {

  void initState() {
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 100,
            child: Text(widget.receipt.name)
          ),
        ),
        SizedBox(
            height: 100,
            width: 100,
            child: Text('\$${widget.receipt.price}')
          ),
      ],
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
          Text(user.name, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}

