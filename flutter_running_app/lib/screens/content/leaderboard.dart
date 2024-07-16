import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final AuthService _auth = AuthService();
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserDistance> _userDistances = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      // This is the collection group query, which gets documents from all 'userActivities' subcollections across the database.
      QuerySnapshot activitiesSnapshot =
          await _firestore.collectionGroup('userActivities').get();

      // A map to keep track of total distances per user.
      Map<String, double> userTotalDistances = {};

      // Iterate over each activity and sum the distances by user.
      for (var activity in activitiesSnapshot.docs) {
        var data = activity.data();
        if (data is Map<String, dynamic>) {
          String userId = data['userID'] as String? ?? 'unknownUser';
          double distance =
              ((data['activityDistance'] as num?)?.toDouble() ?? 0.0) / 1000;

          if (!userTotalDistances.containsKey(userId)) {
            userTotalDistances[userId] = 0.0;
          }
          userTotalDistances[userId] = userTotalDistances[userId]! + distance;
        }
      }

      // Convert the map to a list of UserDistance objects.
      List<UserDistance> distances = userTotalDistances.entries.map((entry) {
        return UserDistance(
          userId: entry.key,
          distance: entry.value,
          displayName: 'User ${entry.key}', // Placeholder for actual user name
        );
      }).toList();

      // Sort the list by distance in descending order.
      distances.sort((a, b) => b.distance.compareTo(a.distance));

      if (mounted) {
        setState(() {
          _userDistances = distances;
        });
      }
      print('Leaderboard loaded with ${_userDistances.length} users.');
    } catch (e) {
      print('Error loading leaderboard: $e');
      if (mounted) {
        setState(() {
          _userDistances = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Total Distance Leaderboard',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                color:
                    secondary), // Assuming `secondary` is a color defined in your constants
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _userDistances.length,
            itemBuilder: (context, index) {
              // Determine if the current list item is the logged-in user
              bool isCurrentUser = _userDistances[index].userId == user!.uid;
              // Create a rank indicator
              String rank = "${index + 1}";

              // Style the current user differently
              TextStyle textStyle = isCurrentUser
                  ? TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
                  : TextStyle(fontWeight: FontWeight.normal);

              // Decide what to display as the name
              String displayName = isCurrentUser
                  ? 'You'
                  : 'User $rank'; // Or any other anonymous naming convention

              return ListTile(
                leading: CircleAvatar(
                  child: Text(rank),
                  backgroundColor: secondary,
                ), // Rank indicator
                title: Text(displayName, style: textStyle),
                subtitle: isCurrentUser
                    ? Text(
                        'Distance: ${_userDistances[index].distance.toStringAsFixed(2)} km')
                    : null,
                trailing: isCurrentUser
                    ? Icon(Icons.star, color: success)
                    : Text(
                        '${_userDistances[index].distance.toStringAsFixed(2)} km'),
                tileColor: isCurrentUser ? success.withOpacity(0.3) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserDistance {
  String userId;
  double distance;
  String displayName;

  UserDistance({
    required this.userId,
    required this.distance,
    required this.displayName,
  });
}
