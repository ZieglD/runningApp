import 'package:flutter/material.dart';
import 'package:flutter_running_app/screens/content/badges_grid.dart';
import 'package:flutter_running_app/screens/content/leaderboard.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:flutter_running_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_running_app/screens/content/progression.dart';
import 'package:flutter_running_app/screens/content/challenges_list.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  User? user = FirebaseAuth.instance.currentUser;
  double _totalDistance = 0.0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadTotalDistance();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Challenges'),
            Tab(text: 'Badges'),
            Tab(text: 'Leaderboard'),
          ],
        ),
      ),
      body: Column(
        children: [
          DistanceProgressBar(totalDistance: _totalDistance),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ChallengesList(),
                BadgesGrid(),
                Leaderboard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
