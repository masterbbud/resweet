import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'SignupPage.dart';

class Landing extends StatelessWidget {
  Function setToken;

  Landing({super.key, required this.setToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Resweet'),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login(setToken: setToken)),
                );
              },
              child: Text('Login'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signup(setToken: setToken)),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const RaisedButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: Colors.blue,
        textColor: Colors.white,
        child: child,
      ),
    );
  }
}
