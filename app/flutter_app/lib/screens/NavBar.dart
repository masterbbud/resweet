import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'dart:io';

import 'ReceiptEditPage.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.selectFunc});

  final Function(int) selectFunc;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.all(0),
      child: Scaffold (

        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 75,
          width: 75,
          child: FittedBox (
              child: FloatingActionButton(
              onPressed: () {
                // pickReceiptFromCamera().then((file) {
                //   if (file != null) {
                //     api.processReceipt(file).then((receipt) {
                //       print(receipt.toString());
                //       Navigator.push(
                //         context,
                //           MaterialPageRoute(builder: (context) => ReceiptEditPage(receipt: receipt)),
                //         );
                //       });
                //     }
                //   });
                  pickReceiptFromCamera().then((rcpt) {
                    if (rcpt != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReceiptEditPage(receipt: rcpt)),
                      );
                    }
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                shape: CircleBorder(),

                child: Icon(Icons.upload, size: 37.74,color: Colors.white,),
              )),

        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 12,
          color: Theme.of(context).colorScheme.onPrimary,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Spacer(),
              IconButton(
                tooltip: 'Home',
                icon: const Icon(Icons.home_outlined),
                onPressed: () {selectFunc(0);},
                iconSize: 37.74,
                color: Colors.white,
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Group',
                icon: const Icon(Icons.group_outlined),
                onPressed: () {selectFunc(2);},
                iconSize: 37.74,
                color: Colors.white,),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              IconButton(
                tooltip: 'Ledger',
                icon: const Icon(Icons.folder_outlined),
                onPressed: () {selectFunc(3);},
                iconSize: 37.74,
                color: Colors.white,),
              const Spacer(),
              IconButton(
                tooltip: 'Account',
                icon: const Icon(Icons.account_circle_outlined),
                onPressed: () {selectFunc(4);},
                iconSize: 37.74,
                color: Colors.white,
              ),
              const Spacer(),
            ],
          ),
        ),
      )
    );
  }

  Future<ReceiptSnapshot?> pickReceiptFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;

    return await api.processReceipt(image);
  }
}
