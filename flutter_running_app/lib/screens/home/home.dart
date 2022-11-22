import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_running_app/screens/authenticate/authenticate.dart';
import 'package:flutter_running_app/screens/authenticate/sign_up.dart';
import 'package:flutter_running_app/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFCA1C),
      appBar: AppBar(
        title: const Text('Running App'),
        foregroundColor: const Color(0xFFF2F2F2),
        backgroundColor: const Color(0xFF393939),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFF2F2F2),
            ),
            onPressed: () async {
              await _auth.signOutFromApp();
            },
          )
        ],
      ),
    );
  }


}