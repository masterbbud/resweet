import 'package:flutter/material.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/screens/GroupPage.dart';
import 'package:flutter_app/screens/HomePage.dart';
import 'package:flutter_app/screens/LedgerPage.dart';
import 'package:flutter_app/screens/NavBar.dart';
import 'package:flutter_app/screens/ProfilePage.dart';

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
      home: NavPageWrapper(),
    );
  }
}

class NavPageWrapper extends StatefulWidget {
  const NavPageWrapper({super.key});

  @override
  State<NavPageWrapper> createState() => _NavPageWrapperState();
}

class _NavPageWrapperState extends State<NavPageWrapper> {

  bool needsUpdate = false;

  final pages = [
    HomePage(),
    GroupPage(),
    LedgerPage(),
    ProfilePage()
  ];

  int pageIndex = 0;

  void selectPage(int index) {
    pageIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // doInitState().then((_) {setState(() {});});
    
    // .then(() => 
    // api.getYourReceipts().then(() =>
    // setState(() {});
    // ))

    initApp();
  }

  // Future<void> doInitState() async {
  //   await api.getYourAccount();
  //   await api.getYourReceipts();
  //   await api.getAllUsers();
  //   print(info.myReceipts);
  //   setState(() {});
  // }

  Future<void> initApp() async {
    try {
      await api.getYourAccount();
      await api.getYourReceipts();
      await api.getAllUsers();
      print(info.myReceipts);
      setState(() {});
    } catch (e) {
      print('Init failed: $e');
    }

    // If setState is called after awaiting above operations, it ensures that
    // the widget updates with the fetched data.
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(selectFunc: selectPage),
      body: pages[pageIndex]
    );
  }
}