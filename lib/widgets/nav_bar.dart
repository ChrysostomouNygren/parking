import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  int currentIndex;
  Function(int) onTap;
  NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
      BottomNavigationBarItem(icon: Icon(Icons.local_parking), label: "Parking"),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "User")
    ]);
  }
}