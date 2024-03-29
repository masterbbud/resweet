import 'package:flutter/material.dart';
import 'package:flutter_app/managers/EverythingManager.dart';
import 'package:flutter_app/screens/GroupPage.dart';
import 'package:flutter_app/screens/HomePage.dart';
import 'package:flutter_app/screens/LandingPage.dart';
import 'package:flutter_app/screens/LedgerPage.dart';
import 'package:flutter_app/screens/NavBar.dart';
import 'package:flutter_app/screens/ProfilePage.dart';
import 'package:localstorage/localstorage.dart';

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
  final storage = LocalStorage('token');

  @override
  void initState() {
    super.initState();
    info.setYourToken(storage.getItem('token'));
  }

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
      themeMode: _themeMode,
      home: info.myToken == null ? Landing(setToken: (token) {
        storage.setItem('token', token);
        info.setYourToken(token);
        api.getYourAccount().then((_) {
          api.getYourReceipts().then((_) {
            api.getAllUsers().then((_) {
              setState(() {});
            });
          });
        });
      },) : NavPageWrapper(),
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
    // initApp();
  }

  Future<void> initApp() async {
    try {
      await api.getYourAccount();
      await api.getYourReceipts();
      await api.getAllUsers();
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