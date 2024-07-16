// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_running_app/models/challenge.dart';
// import 'package:flutter_running_app/services/database.dart';

// class ChallengesList extends StatelessWidget {
//   final DatabaseService _firestoreService = DatabaseService();
//   User? user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Challenge>>(
//       // Adjust the stream to point to the user's subcollection of challenges
//       stream: _firestoreService.getUserChallenges(user!.uid),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No challenges found.'));
//         }

//         List<Challenge> challenges = snapshot.data!;

//         return ListView.builder(
//           itemCount: challenges.length,
//           itemBuilder: (context, index) {
//             Challenge challenge = challenges[index];
//             return ListTile(
//               title: Text(challenge.title),
//               subtitle: Text(challenge.description),
//               trailing: challenge.isCompleted
//                   ? Icon(Icons.check_circle, color: Colors.green)
//                   : Icon(Icons.radio_button_unchecked),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_running_app/models/challenge.dart';
import 'package:flutter_running_app/services/database.dart';

class ChallengesList extends StatelessWidget {
  final DatabaseService _firestoreService = DatabaseService();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Challenge>>(
      // Adjust the stream to point to the user's subcollection of challenges
      stream: _firestoreService.getUserChallenges(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No challenges found.'));
        }

        List<Challenge> challenges = snapshot.data!;

        return ListView.builder(
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            Challenge challenge = challenges[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.all(12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                title: Text(challenge.title),
                subtitle: Text(challenge.description),
                trailing: challenge.isCompleted
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.radio_button_unchecked),
              ),
            );
          },
        );
      },
    );
  }
}
