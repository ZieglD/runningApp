import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        leading: const Icon(
          Icons.directions_run_rounded,
          color: primary,
        ),
        title: const Text('Running App'),
        centerTitle: true,
        foregroundColor: light,
        backgroundColor: secondary,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            style: TextButton.styleFrom(
              foregroundColor: light,
            ),
            onPressed: () async {
              await _auth.signOutFromApp();
            },
          )
        ],
      ),
      body:
          const Center(child: Text('Profile', style: TextStyle(fontSize: 60))),
    );
  }
}
