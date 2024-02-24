import 'package:flutter/material.dart';
import 'package:flutter_app/interfaces.dart';
import 'package:flutter_app/screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});


  // This widget is the root of your application
  
  @override
  State<MyApp> createState() => AppState();
}

class AppState extends State<MyApp> {

  List<User> users = List<User>.from([User(uuid: "1", name: "Brandon Faunce", color: Colors.red), User(uuid: "1", name: "Raynard Miot", color: Colors.purple), User(uuid: "1", name: "Danil Donchuk", color: Colors.orange), User(uuid: "1", name: "Jan Li", color: Colors.green)]);
  List<Transaction> transactions = [
    Transaction(date: "1/11/24", from: "Dan Donchuk", amount: 50),
    Transaction(date: "1/11/24", from: "Dan Donchuk", amount: -50),
    Transaction(date: "1/11/24", from: "Dan Donchuk", amount: -50)
  ];

  User myUser = User(uuid: "1", name: "Brandon Faunce", color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,
                                          onPrimary: Color(0xFF4CC9F0),
                                          onSecondary: Color(0xFFF96368),
        ),
        useMaterial3: true,
      ),
      home: HomePage(title: 'HomePage', myUser: myUser, users: users, transactions: transactions),
    );
  }
}