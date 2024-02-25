import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../managers/EverythingManager.dart';

class Login extends StatefulWidget {
  Login({super.key, required this.setToken});
  final Function setToken;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Resweet'),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onSaved: (value) => username = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
              return null;
              },
              onSaved: (value) => password = value ?? '',
            ),
            RaisedButton(
              onPressed: submit,
              child: const Text('Login'),
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
      margin: const EdgeInsets.all(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: Colors.blue,
        textColor: Colors.white,
        child: child,
      ),
    );
  }
}

