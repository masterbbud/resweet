import 'package:flutter/material.dart';
import 'package:flutter_app/screens/HomePage.dart';
import '../managers/EverythingManager.dart';

class Signup extends StatefulWidget {
  const Signup({super.key, required this.setToken});
  final Function setToken;

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController displayController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      api.signup(
          usernameController.text,
          displayController.text,
          passwordController.text
      ).then((token) {
        if (token != null) {
          widget.setToken(token);
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Welcome to the Resweet'),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length > 16) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: displayController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Display Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your display name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: submit,
                child: const Text('Signup'),
              ),
            ],
          ),
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
