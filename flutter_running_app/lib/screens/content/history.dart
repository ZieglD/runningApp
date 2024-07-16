import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:flutter_running_app/shared/activities_list.dart';
import '../../services/database.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final AuthService _auth = AuthService();
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid);
  User? user = FirebaseAuth.instance.currentUser;

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
      body: Column(
        children: [
          Material(
            elevation: 4.0,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Text(
                "Your Running History",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: secondary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: ActivitiesList(
              databaseService: databaseService,
            ),
          ),
        ],
      ),
    );
  }
}
