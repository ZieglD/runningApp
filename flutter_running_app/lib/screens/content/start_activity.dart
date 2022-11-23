import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_running_app/screens/navigation/navigation.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';

class StartActivity extends StatefulWidget {
  const StartActivity({super.key});

  @override
  State<StartActivity> createState() => _StartActivityState();
}

class _StartActivityState extends State<StartActivity> {
  final AuthService _auth = AuthService();
  bool _showAppBar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: _showAppBar
          ? AppBar(
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
            )
          : null,
      body:
          const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
      //     ElevatedButton(
      //   onPressed: () => setState(() => _showAppBar = !_showAppBar),
      //   child: const Text('Hide Appbar'),
      // ),
    );
  }
}
