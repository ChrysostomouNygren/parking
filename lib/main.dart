import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/nav_bar.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/vehicle_screen.dart';
import 'screens/login_screen.dart';


void main() { 
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isLoggedIn;
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    VehicleScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _isLoggedIn = false;
      _selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vroominator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vroominator'),
          actions: _isLoggedIn == true ? [IconButton(icon: const Icon(Icons.logout),
          onPressed: _logout,
          )
          ]
          : null,
        ),
        body: _isLoggedIn == null ? const Center(child: CircularProgressIndicator())
          : _isLoggedIn == true ? _screens[_selectedIndex]
          : LoginScreen(onLoginSuccess: _onLoginSuccess),
        bottomNavigationBar: _isLoggedIn == true ? NavBar(currentIndex: _selectedIndex, onTap: _onItemTapped) : null,
      ),
    );
  }
}