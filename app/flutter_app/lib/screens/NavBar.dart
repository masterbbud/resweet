import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/managers/EverythingManager.dart';

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
                  ImagePicker().pickImage(source: ImageSource.camera).then((image) {
                    if (image == null) return;

                    // Loading modal
                    showDialog(
                      context: context,
                      barrierDismissible: false, // Prevents the dialog from being dismissed accidentally
                      builder: (BuildContext context) {
                        return const Dialog(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Text("Processing receipt..."),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    api.processReceipt(image).then((rcpt) {
                      // Close the loading modal
                      Navigator.pop(context);

                      // If the image could not be parsed
                      if (rcpt.isNone()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Image could not be processed! Are you sure it was a receipt?"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Dismiss the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReceiptEditPage(receipt: rcpt)),
                      );
                    });
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
}
