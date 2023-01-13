import 'package:flutter/material.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/services/database.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_running_app/shared/activities_list.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          leading: const Icon(
            Icons.directions_run_rounded,
            color: success,
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
        // body: const Center(
        //     child: Text('History', style: TextStyle(fontSize: 60))),
        body: ActivitiesList());
  }
}
