import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_running_app/screens/content/start_activity.dart';
import 'package:flutter_running_app/screens/content/history.dart';
import 'package:flutter_running_app/screens/content/profile.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/screens/authenticate/authenticate.dart';
import 'package:flutter_running_app/screens/authenticate/sign_up.dart';
import '../../shared/constants.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final AuthService _auth = AuthService();
  int currentIndex = 1;
  // ignore: prefer_final_fields
  bool _showBottomNavigationBar = true;

  final screens = [
    const History(),
    const StartActivity(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secondary,
        selectedItemColor: success,
        unselectedItemColor: light,
        currentIndex: currentIndex,
        showUnselectedLabels: false,
        iconSize: 30,
        onTap: (index) => setState(() => currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Start Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
