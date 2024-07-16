import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_running_app/screens/content/progression.dart';
import 'package:flutter_running_app/screens/navigation/navigation.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/services/database.dart';
import 'package:flutter_running_app/shared/map_widget_end.dart';
import 'package:flutter_running_app/shared/most_recent_activity_card.dart';

import '../../shared/constants.dart';

class EndActivity extends StatefulWidget {
  const EndActivity({super.key});

  @override
  State<EndActivity> createState() => _EndActivityState();
}

class _EndActivityState extends State<EndActivity> {
  final AuthService _auth = AuthService();
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid);
  User? user = FirebaseAuth.instance.currentUser;
  double _totalDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTotalDistance();
  }

  // fetch total distance needed for progress bar
  Future<void> _loadTotalDistance() async {
    double totalDistance =
        await DatabaseService(uid: user?.uid).getTotalActivityDistance();
    setState(() {
      _totalDistance = totalDistance;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User?>(context);
    User? user = FirebaseAuth.instance.currentUser;

    Widget finishButton = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 70,
        padding: EdgeInsets.only(bottom: 10),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: success,
              //minimumSize: Size(200, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          onPressed: () /*async*/ {
            // await DatabaseService(uid: user?.uid)
            //     .updateActivities(user!.uid, savedDistance);
            // await DatabaseService()
            //     .checkAndCompleteChallenges(user.uid, savedDistance);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Navigation()));
          },
          icon: const Icon(
            Icons.flag,
            color: secondary,
            size: 35,
          ),
          label: const Text(
            'Finish Run',
            style: TextStyle(color: secondary, fontSize: 25),
          ),
        ),
      ),
    );

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
      ),
      // body: const Center(child: Text('End', style: TextStyle(fontSize: 60))),
      body: Column(
        children: [
          Expanded(
            // Wrap the content you want to scroll in an Expanded widget
            child: SingleChildScrollView(
              // Use SingleChildScrollView to make the content scrollable
              child: Column(
                children: [
                  DistanceProgressBar(totalDistance: _totalDistance),
                  MostRecentActivityCard(databaseService: databaseService),
                ],
              ),
            ),
          ),
          finishButton, // Keep the finishButton outside the SingleChildScrollView
        ],
      ),
    );
  }
}
