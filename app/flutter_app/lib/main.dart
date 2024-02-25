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
  ThemeMode _themeMode = ThemeMode.light;
  @override
  AppState createState() => AppState();
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  static AppState of(BuildContext context) =>
      context.findAncestorStateOfType<AppState>()!;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
            background: Color(0xFF231836),
            onPrimary: Color(0xFF4CC9F0),
            onSecondary: Color(0xFFF96368),
        onTertiary: Color(0xFF1C1130)),

      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,
                                          onPrimary: Color(0xFF4CC9F0),
                                          onSecondary: Color(0xFFF96368),
                                          onTertiary: Color(0xFFF9F9F9),
        ),
        useMaterial3: true,
      ),
      home: NavPageWrapper(),
      themeMode: _themeMode
    );
  }

  ThemeMode getTheme() { return _themeMode;}
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